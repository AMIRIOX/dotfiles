-- ~/.config/nvim/lua/utils/jdtls_conf.lua

local M = {}

local JAVA_HOME = os.getenv("JAVA_HOME")

local function get_project_settings(root_dir)
    local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()

    local project_name = vim.fn.fnamemodify(root_dir, ":t")

    local lombok_jar_path = vim.fn.glob(root_dir .. "/lombok*.jar", 0, 1)[1]
        or vim.fn.glob(root_dir .. "/**/lombok*.jar", 0, 1)[1]
        or ""

    local vmargs = {
        "-javaagent:" .. lombok_jar_path,
        "-Xms1g",
        "-Xmx2g",
        "--add-opens",
        "java.base/java.util=ALL-UNNAMED",
        "--add-opens",
        "java.base/java.lang=ALL-UNNAMED",
    }

    if lombok_jar_path == "" then
        table.remove(vmargs, 1)
    else
        print("Lombok found at: " .. lombok_jar_path)
    end

    local bundles = {}

    -- more extension
    --[[
    local java_test_bundle_path = vim.fn.glob(
        vim.fn.stdpath("data")
            .. "/mason/packages/java-test/extension/server/*.jar",
        0,
        1
    )[1]
    if java_test_bundle_path then
        table.insert(bundles, java_test_bundle_path)
    else
        print(
            "java-test bundle not found. Ensure it's installed via Mason or manually."
        )
    end

    local java_decompiler_bundle_path = vim.fn.glob(
        vim.fn.stdpath("data") .. "/mason/packages/java-decompiler/server/*.jar",
        0,
        1
    )[1]
    if java_decompiler_bundle_path then
        table.insert(bundles, java_decompiler_bundle_path)
    else
        print(
            "java-decompiler bundle not found. Ensure it's installed via Mason or manually."
        )
    end
    ]]

    local project_sdk_path

    if
        vim.fn.filereadable(root_dir .. "/build.gradle") == 1
        or vim.fn.filereadable(root_dir .. "/build.gradle.kts") == 1
    then
        print(
            "Gradle project detected. Consider setting specific Gradle JDK if needed."
        )
        -- project_sdk_path = "/path/to/gradle/jdk"
    elseif vim.fn.filereadable(root_dir .. "/pom.xml") == 1 then
        print(
            "Maven project detected. Consider setting specific Maven JDK if needed."
        )
        project_sdk_path = JAVA_HOME
    end

    return {
        cmd = {
            vim.fn.stdpath("data") .. "/mason/bin/jdtls",
            "-data",
            vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name,
            "-configuration",
            vim.fn.stdpath("config") .. "/jdtls-config",
        },
        root_dir = root_dir,
        settings = {
            java = {
                home = project_sdk_path,
                eclipse = {
                    downloadSources = true,
                },
                configuration = {
                    runtimes = {
                        {
                            name = "JavaSE-21",
                            path = "/usr/lib/jvm/java-21-openjdk/",
                        },
                        {
                            name = "JavaSE-24",
                            path = "/usr/lib/jvm/java-24-openjdk/"
                        },
                    },
                },
                import = {
                    gradle = {
                        enabled = false,
                        -- java = {
                        --   home = "/path/to/gradle/jdk"
                        -- },
                    },
                    maven = {
                        enabled = true,
                    },
                },
                signatureHelp = { enabled = true },
                contentProvider = { preferred = "fernflower" },
                implementationsCodeLens = { enabled = true },
                referencesCodeLens = { enabled = true },
                references = {
                    includeDecompiledSources = true,
                },
                saveActions = {
                    organizeImports = true,
                },
                format = {
                    enabled = true,
                    -- Eclipse JDT LS formatter config file (xml)
                    -- settings = {
                    --   url = "/path/to/your/java-formatter.xml",
                    --   profile = "GoogleStyle",
                    -- },
                    comments = {
                        enabled = true,
                    },
                },
                -- Lombok config
                -- vmargs = table.concat(vmargs, ' '),
                -- jdt = {
                --   ls = {
                --     vmargs = vmargs,
                --   }
                -- }
            },
        },
        init_options = {
            bundles = bundles,
            extendedClientCapabilities = {
                progressReportProvider = true,
                typeHierarchy = true,
                shouldLanguageServerExitOnShutdown = true,
            },
        },
        on_attach = function(client, bufnr)
            local map = vim.keymap.set
            local opts = { buffer = bufnr, noremap = true, silent = true }

            map("n", "gd", vim.lsp.buf.definition, opts)
            map("n", "K", vim.lsp.buf.hover, opts)
            map("n", "gi", vim.lsp.buf.implementation, opts)
            map("n", "gr", vim.lsp.buf.references, opts)
            map("n", "gl", vim.diagnostic.open_float, opts)
            map("n", "<leader>lf", function()
                vim.lsp.buf.format({ async = true })
            end, opts)
            map("n", "<leader>la", vim.lsp.buf.code_action, opts)
            map("n", "<leader>lr", vim.lsp.buf.rename, opts)
            map("n", "<leader>lo", "<Cmd>JdtUpdateDebugSettings<CR>", opts)
            map("n", "<leader>ljc", "<Cmd>JdtCompile<CR>", opts)
            map("n", "<leader>lji", "<Cmd>JdtUpdateConfig<CR>", opts)

            map("n", "<leader>jco", "<Cmd>JdtOrganizeImports<CR>", opts)
            map("n", "<leader>jca", function()
                vim.lsp.buf.code_action({ context = { only = { "source" } } })
            end, opts)
            map("n", "<leader>jce", "<Cmd>JdtExtractConstant<CR>", opts)
            map("n", "<leader>jcv", "<Cmd>JdtExtractVariable<CR>", opts)
            map("n", "<leader>jcm", "<Cmd>JdtExtractMethod<CR>", opts)
            map("v", "<leader>jcm", "<Esc><Cmd>JdtExtractMethod<CR>", opts)

            -- Java debug (nvim-dap & nvim-jdtls needed)
            -- map('n', '<leader>jd', function() require('jdtls').test_class() end, opts)
            -- map('n', '<leader>jn', function() require('jdtls').test_nearest_method() end, opts)

            if client.server_capabilities.inlayHintProvider then
                vim.lsp.inlay_hint.enable(bufnr, true)
                map("n", "<leader>lh", function()
                    vim.lsp.inlay_hint.enable(
                        bufnr,
                        not vim.lsp.inlay_hint.is_enabled(bufnr)
                    )
                end, opts)
            end

        end,
        capabilities = lsp_capabilities,

        vmargs = table.concat(vmargs, " "),
    }
end

M.setup = function()
    local jdtls = require("jdtls")
    local root_markers = {
        ".git",
        "mvnw",
        "gradlew",
        "pom.xml",
        "build.gradle",
        "build.gradle.kts",
    }
    local root_dir = require("jdtls.setup").find_root(root_markers)

    if not root_dir then
        print("JDTLS: Could not find project root. Aborting setup.")
        return
    end

    local project_config = get_project_settings(root_dir)

    jdtls.start_or_attach(project_config)

    vim.api.nvim_create_user_command("JdtCompile", function()
        jdtls.compile()
    end, { desc = "Compile Java project using JDTLS" })

    vim.api.nvim_create_user_command("JdtUpdateConfig", function()
        jdtls.update_project_config()
    end, { desc = "Update JDTLS project configuration" })

    vim.api.nvim_create_user_command("JdtOrganizeImports", function()
        jdtls.organize_imports()
    end, { desc = "Organize Java imports using JDTLS" })

    vim.api.nvim_create_user_command("JdtExtractConstant", function(opts)
        jdtls.extract_constant(opts.fargs[1])
    end, {
        nargs = "?",
        desc = "Extract to constant (provide name or will prompt)",
    })

    vim.api.nvim_create_user_command("JdtExtractVariable", function(opts)
        jdtls.extract_variable(opts.fargs[1])
    end, {
        nargs = "?",
        desc = "Extract to variable (provide name or will prompt)",
    })

    vim.api.nvim_create_user_command("JdtExtractMethod", function()
        jdtls.extract_method(true)
    end, { range = true, desc = "Extract method from selection" })

    -- nvim-dap
    -- require('jdtls').setup_dap({ hotcodereplace = 'auto' })
    -- require('config.dap.java').setup()
end

return M
