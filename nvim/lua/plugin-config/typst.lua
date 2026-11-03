-- Typst:tinymist 提供 LSP(补全/诊断/跳转/格式化)
-- 本地笔记模板与预览脚本在 ~/notes(nv 里 <leader>np 直接开)
local np = vim.fn.expand("~/notes/np")

if vim.fn.executable("tinymist") == 1 then
    vim.lsp.config("tinymist", {
        cmd = { "tinymist" },
        filetypes = { "typst" },
        root_markers = { "typst.toml" },
        settings = {
            tinymist = {
                formatterMode = "typstyle",
            },
        },
    })
    vim.lsp.enable("tinymist")
else
    vim.schedule(function()
        vim.notify(
            "tinymist 不在 PATH:Typst 补全/预览不可用",
            vim.log.levels.WARN
        )
    end)
end

local function typst_cmd(mode)
    local file = vim.api.nvim_buf_get_name(0)
    if file == "" or not file:match("%.typ$") then
        vim.notify("当前 buffer 不是 .typ 文件", vim.log.levels.WARN)
        return
    end
    if not vim.uv.fs_stat(np) then
        vim.notify("找不到 " .. np, vim.log.levels.ERROR)
        return
    end
    if mode == "build" then
        local out = {}
        vim.fn.jobstart({ np, mode }, {
            env = { SRC = file },
            stdout_buffered = true,
            on_stdout = function(_, data)
                for _, line in ipairs(data or {}) do
                    if line ~= "" then
                        table.insert(out, line)
                    end
                end
            end,
            on_exit = function(_, code)
                vim.schedule(function()
                    vim.notify(
                        table.concat(out, "\n"),
                        code == 0 and vim.log.levels.INFO or vim.log.levels.ERROR
                    )
                end)
            end,
        })
    else
        -- detach:预览服务/阅读器独立于 nvim 存活
        vim.fn.jobstart({ np, mode }, { env = { SRC = file }, detach = true })
        vim.notify("Typst " .. mode .. " 已启动", vim.log.levels.INFO)
    end
end

vim.keymap.set("n", "<leader>np", function()
    typst_cmd("preview")
end, { desc = "Typst: 浏览器实时预览" })

vim.keymap.set("n", "<leader>nP", function()
    typst_cmd("pdf")
end, { desc = "Typst: PDF + zathura 实时跟随" })

vim.keymap.set("n", "<leader>nb", function()
    typst_cmd("build")
end, { desc = "Typst: 导出 PDF" })
