-- lsp/kind.lua
local lspkind = require("lspkind")
lspkind.init({
  mode = "symbol_text",
  preset = "default",
  symbol_map = {
    Error = "[X]",
    Text = "[T]",
    Method = "[M]",
    Function = "[F]",
    Constructor = "[C]",
    Field = "󰜢",
    Variable = "󰀫",
    Class = "󰠱",
    Interface = "",
    Module = "",
    Property = "󰜢",
    Unit = "󰑭",
    Value = "󰎠",
    Enum = "",
    Keyword = "󰌋",
    Snippet = "",
    Color = "󰏘",
    File = "󰈙",
    Reference = "󰈇",
    Folder = "󰉋",
    EnumMember = "",
    Constant = "󰏿",
    Struct = "󰙅",
    Event = "",
    Operator = "󰆕",
    TypeParameter = ""
  },
})

