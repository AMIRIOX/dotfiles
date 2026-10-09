local cmd = { vim.fn.expand("~/devs/skhole/target/release/skhole-tui") }
local terminal_buf

-- Re-sourcing this config should adopt the running TUI rather than spawn another.
for _, buf in ipairs(vim.api.nvim_list_bufs()) do
  if vim.bo[buf].buftype == "terminal" and vim.b[buf].term_title == "skhole" then
    terminal_buf = buf
    local job = vim.b[buf].terminal_job_id
    if job and vim.fn.jobwait({ job }, 0)[1] == -1 then
      break
    end
  end
end

local function configure_window()
  vim.wo.number = false
  vim.wo.relativenumber = false
  vim.wo.signcolumn = "no"
  vim.wo.foldcolumn = "0"
  vim.wo.foldenable = false
  vim.wo.statuscolumn = ""
  vim.wo.colorcolumn = ""
  vim.wo.cursorline = false
  vim.wo.cursorcolumn = false
  vim.wo.wrap = false
  vim.wo.linebreak = false
  vim.wo.breakindent = false
  vim.wo.list = false
  vim.wo.spell = false
  -- Terminal-normal mode otherwise restores the editor's scroll margins and
  -- scrolls a full-width TUI sideways; entering terminal input does not undo it.
  vim.wo.scrolloff = 0
  vim.wo.sidescrolloff = 0
  vim.fn.winrestview({ leftcol = 0, skipcol = 0 })
end

vim.api.nvim_create_autocmd("TermEnter", {
  group = vim.api.nvim_create_augroup("SkholeViewport", { clear = true }),
  callback = function(args)
    if args.buf == terminal_buf then
      configure_window()
    end
  end,
})

local function enter_terminal()
  configure_window()
  vim.cmd.startinsert()
end

local function open()
  if vim.fn.has("nvim-0.11") == 0 then
    vim.notify("skhole: Neovim 0.11 or newer is required", vim.log.levels.ERROR)
    return
  end

  local old_buf = terminal_buf
  if old_buf and not vim.api.nvim_buf_is_valid(old_buf) then
    old_buf = nil
  end
  local old_win = old_buf and vim.fn.win_findbuf(old_buf)[1]
  local job = old_buf and vim.b[old_buf].terminal_job_id
  if job and vim.fn.jobwait({ job }, 0)[1] == -1 then
    if old_win then
      vim.api.nvim_set_current_win(old_win)
    else
      vim.cmd("tab sbuffer " .. old_buf)
    end
    enter_terminal()
    return
  end

  if vim.fn.executable(cmd[1]) ~= 1 then
    vim.notify(
      "skhole: executable not found: " .. cmd[1]
        .. "; build it with cargo build -p skhole-tui --release --locked",
      vim.log.levels.ERROR
    )
    return
  end

  -- Reuse the tab of an exited process, keeping its output until the next launch.
  local previous_win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_create_buf(true, true)
  if old_win then
    vim.api.nvim_set_current_win(old_win)
    vim.api.nvim_win_set_buf(old_win, buf)
  else
    vim.cmd("tab sbuffer " .. buf)
  end
  local win = vim.api.nvim_get_current_win()
  -- Set the text area before spawning the PTY, including inherited editor columns.
  configure_window()
  local ok, result = pcall(vim.fn.jobstart, cmd, { term = true })
  if not ok or result <= 0 then
    if old_win then
      vim.api.nvim_win_set_buf(old_win, old_buf)
    else
      vim.api.nvim_win_close(win, true)
    end
    vim.api.nvim_buf_delete(buf, { force = true })
    vim.api.nvim_set_current_win(previous_win)
    vim.notify("skhole: could not start TUI: " .. tostring(result), vim.log.levels.ERROR)
    return
  end

  terminal_buf = buf
  vim.bo[buf].buflisted = true
  vim.bo[buf].bufhidden = "hide"
  vim.bo[buf].swapfile = false
  vim.b[buf].term_title = "skhole"
  -- Esc cancels TUI dialogs, even when a global terminal mapping uses it to leave.
  vim.keymap.set("t", "<Esc>", "<Esc>", { buffer = buf, desc = "Send Esc to skhole" })
  -- Leave terminal input, then reuse the user's normal-mode buffer mappings.
  for _, key in ipairs({ "<C-h>", "<C-l>" }) do
    vim.keymap.set("t", key, "<C-\\><C-n>" .. key, {
      buffer = buf,
      remap = true,
      silent = true,
      desc = "Use Neovim " .. key .. " mapping",
    })
  end
  vim.api.nvim_create_autocmd("BufWinEnter", {
    buffer = buf,
    callback = function()
      configure_window()
      vim.schedule(function()
        if vim.api.nvim_get_current_buf() == buf and vim.fn.jobwait({ result }, 0)[1] == -1 then
          vim.cmd.startinsert()
        end
      end)
    end,
  })
  if old_buf then
    vim.api.nvim_buf_delete(old_buf, { force = true })
  end
  enter_terminal()
end

vim.api.nvim_create_user_command("Skhole", open, {
  desc = "Open or resume the skhole TUI",
  nargs = 0,
})
