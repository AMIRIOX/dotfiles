local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local luasnip = require("luasnip")
local cmp = require("cmp")
local lspkind = require('lspkind') 

local function oneline(text)
    return text:gsub("\n", " "):gsub("%s+", " "):gsub("^%s*(.-)%s*$", "%1")
end

cmp.setup({
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        end,
    },
    mapping = cmp.mapping.preset.insert({
        -- Use <C-b/f> to scroll the docs
        ['<C-b>'] = cmp.mapping.scroll_docs( -4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        -- Use <C-k/j> to switch in items
        ['<C-k>'] = cmp.mapping.select_prev_item(),
        ['<C-j>'] = cmp.mapping.select_next_item(),
        -- Use <CR>(Enter) to confirm selection
        -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ['<CR>'] = cmp.mapping.confirm({ select = true }),

        -- A super tab
        -- sourc: https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#luasnip
        ["<Tab>"] = cmp.mapping(function(fallback)
            -- Hint: if the completion menu is visible select next one
            if cmp.visible() then
                cmp.select_next_item()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { "i", "s" }), -- i - insert mode; s - select mode
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable( -1) then
                luasnip.jump( -1)
            else
                fallback()
            end
        end, { "i", "s" }),
    }),

    window = {
      -- customize the appearance of the completion menu
      completion = { border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }, scrollbar = "║" },
      documentation = { border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }, scrollbar = "║", },
    },
  -- Let's configure the item's appearance
  -- source: https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance
  formatting = {
    fields = { 'abbr', 'kind', 'menu' },

    format = lspkind.cmp_format({
      mode = "symbol_text",
      maxwidth = 20,
      ellipsis_char = "...",
      show_labelDetails = true, -- show labelDetails in menu. Disabled by default
      before = function(entry, vim_item)
        local word = entry:get_insert_text()
        if entry.completion_item.insertTextFormat == vim.lsp.protocol.InsertTextFormat.Snippet then
          word = vim.lsp.util.parse_snippet(word)
        end
        word = oneline(word)
        if entry.completion_item.insertTextFormat == vim.lsp.protocol.InsertTextFormat.Snippet 
            and string.sub(vim_item.abbr, -1, -1) == "~" then
          word = word .. "~"
        end
        vim_item.abbr = word
        vim_item.menu = ( {
          nvim_lsp = '[Lsp]',
          luasnip = '[Luasnip]',
          buffer = '[File]',
          path = '[Path]',
        })[entry.source.name] or '[Unknown]'

        return vim_item
      end,
    })
  },

  -- Set source precedence
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },    -- For nvim-lsp
    { name = 'luasnip' },     -- For luasnip user
    { name = 'buffer' },      -- For buffer word completion
    -- For path completion
    {
      name = "path",
      entry_filter = function(entry, ctx)
        local line = ctx.cursor_line
        local col = ctx.cursor.col
        local char_before = line:sub(col - 1, col - 1)
        local char_after = line:sub(col, col)

        local in_string = false
        if char_before == '"' or char_before == "'" or char_after == '"' or char_after == "'" then
          in_string = true
        end

        return in_string
      end
    }
  })
})

vim.cmd [[highlight Pmenu guibg=NONE]]
--vim.cmd [[highlight PmenuSel guibg=NONE]]
--vim.cmd [[highlight PmenuThumb guibg=NONE]]
vim.cmd [[highlight PmenuSbar guibg=NONE]]
