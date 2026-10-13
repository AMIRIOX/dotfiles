# Tooling

- Prefers native/built-in functionality over third-party plugins whenever the native option can cover the need ("有原生尽量用原生"), e.g. choosing Neovim's built-in treesitter over the `nvim-treesitter` plugin. Confidence: 0.8
- Pragmatic about that preference: will still add a plugin when the native API genuinely lacks the capability (e.g. textobjects), and expects the tradeoff to be explained rather than assumed. Confidence: 0.7
- Dislikes overlapping/duplicated layering in tooling — having a built-in feature and an external plugin that both do the job, plus multiple competing branches of the same project ("内置一个, 外置又一个…还同时有 master 和 main 分支, 这也太难绷了"). Store-bought simplicity: one clear source of truth beats parallel options. Confidence: 0.5
- Prefers reusing existing/standard keybindings over introducing new custom ones when the existing mapping may already cover the need (e.g. questioning whether `[f` is necessary when `]m`/`]M` exist). Confidence: 0.6
- Values uniform behavior across all languages/filetypes over per-language special-casing, and is willing to disable a built-in per-filetype feature (e.g. `vim.g.no_python_maps = true`) to get consistent global behavior. Confidence: 0.6
