-- macOS 输入法自动切换
-- 只做单向:离开插入模式(normal)时切回英文,
-- 避免中文输入法在 normal 模式下误触(如按 k 被当成拼音候选)。
--
-- 为什么不在进入插入模式时自动切中文:
-- macOS 上可靠切到 CJK 输入法,唯一办法是让 macism 开一个临时窗口强抢前台焦点
-- (否则只是菜单栏图标变了、输入法并没真正生效)。那个约 150ms 的抢焦点窗口里,
-- 敲下的键会发给临时窗口而丢失 —— 例如 `.map(f)` 选中 f 后敲 || 会丢一个 |。
-- 所以这里不做自动切中文,要打中文请手动按 Shift / 输入法切换键。
--
-- 仅 macOS 生效(依赖 macism: brew install laishulu/homebrew/macism);
-- Windows / Linux 不启用。
-- 查看当前输入法 id:直接运行 macism

local M = {}

-- 英文输入法(ABC)。中文输入法不再自动切换,故不需要它的 id。
M.english = "com.apple.keylayout.ABC"

local function resolve_cmd()
    if vim.fn.executable("macism") == 1 then
        return "macism"
    end
    if vim.fn.executable("im-select") == 1 then
        return "im-select"
    end
    return nil
end

function M.setup()
    -- 仅 macOS;Windows / Linux 直接跳过
    if vim.fn.has("mac") ~= 1 then
        return
    end

    local cmd = resolve_cmd()
    if not cmd then
        vim.notify(
            "ime: 未找到 macism,输入法自动切换未启用",
            vim.log.levels.WARN
        )
        return
    end

    local function to_english()
        vim.fn.system({ cmd, M.english })
    end

    local group = vim.api.nvim_create_augroup("ImeSwitch", {
        clear = true,
    })

    -- 离开插入模式 -> 英文(即回到 normal 时)
    vim.api.nvim_create_autocmd("InsertLeave", {
        group = group,
        callback = to_english,
    })
    -- 重新获得焦点时同步(对应"切窗口后卡输入法"的场景):
    -- 只要不在插入模式就切英文;在插入模式则不动,避免打断手动选的中文
    vim.api.nvim_create_autocmd("FocusGained", {
        group = group,
        callback = function()
            if vim.api.nvim_get_mode().mode:sub(1, 1) ~= "i" then
                to_english()
            end
        end,
    })
    -- 启动时先切回英文
    vim.api.nvim_create_autocmd("VimEnter", {
        group = group,
        callback = to_english,
    })
end

return M
