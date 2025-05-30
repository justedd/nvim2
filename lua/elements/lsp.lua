--[[
require('lspconfig').ruby_lsp.setup {
    init_options = {
        enabledFeatures = {
            'codeActions',
            'codeLens',
            'completion',
            'definition',
            'documentHighlights',
            'documentLink',
            'documentSymbols',
            'foldingRanges',
            'formatting',
            'hover',
            'inlayHint',
            'onTypeFormatting',
            'selectionRanges',
            'semanticHighlighting',
            'signatureHelp',
            'typeHierarchy',
            'workspaceSymbol',
        },
        disabledFeatures = {
            'rails',
        },
    },
}
--]]
--
--vim.lsp.enable('ruby_lsp')
require('lspconfig').ruby_lsp.setup {
    handlers = {
        ["textDocument/publishDiagnostics"] = vim.lsp.with(
            vim.lsp.diagnostic.on_publish_diagnostics, {
                virtual_text = false,
                signs = false,
                underline = false
            }
        )
    },
}

--require('lspconfig').solargraph.setup {
    --handlers = {
        --["textDocument/publishDiagnostics"] = vim.lsp.with(
            --vim.lsp.diagnostic.on_publish_diagnostics, {
                --virtual_text = false,
                --signs = false,
                --underline = false
            --}
        --)
    --},
--}
--]]

require('lspconfig').rust_analyzer.setup {
    cmd = { "/home/justed/core/apps/rust-analyzer" },
    handlers = {
        ["textDocument/publishDiagnostics"] = vim.lsp.with(
            vim.lsp.diagnostic.on_publish_diagnostics, {
                virtual_text = false,
                signs = false
            }
        )
    },
}

require('lspconfig').gopls.setup {
    settings = {
        gopls = {
            buildFlags = { "-tags=integration" },
        }
    }
}

require('lspconfig').lua_ls.setup {
    on_init = function(client)
        local path = client.workspace_folders[1].name
        if vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc') then
            return
        end

        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
                -- Tell the language server which version of Lua you're using
                -- (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT'
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME
                    -- Depending on the usage, you might want to add additional paths here.
                    -- "${3rd}/luv/library"
                    -- "${3rd}/busted/library",
                }
                -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                -- library = vim.api.nvim_get_runtime_file("", true)
            }
        })
    end,
    settings = {
        Lua = {}
    },
}
