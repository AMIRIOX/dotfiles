local crates = require("crates")

crates.setup({
    completion = {
        insert_closing_quote = true,

        text = {
            prerelease = "   %s",
            yanked = "   %s",
        },
    },
})

local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<leader>ct", crates.toggle, opts)
vim.keymap.set("n", "<leader>cr", crates.reload, opts)

-- version
vim.keymap.set("n", "<leader>cv", crates.show_versions_popup, opts)
vim.keymap.set("n", "<leader>cf", crates.show_features_popup, opts)
vim.keymap.set("n", "<leader>cu", crates.update_crate, opts)
vim.keymap.set("v", "<leader>cu", crates.update_crates, opts)
vim.keymap.set("n", "<leader>ca", crates.update_all_crates, opts)
vim.keymap.set("n", "<leader>cU", crates.upgrade_crate, opts)
vim.keymap.set("v", "<leader>cU", crates.upgrade_crates, opts)
vim.keymap.set("n", "<leader>cA", crates.upgrade_all_crates, opts)

-- dep
vim.keymap.set("n", "<leader>cd", crates.open_documentation, opts)
vim.keymap.set("n", "<leader>cc", crates.open_crates_io, opts)
