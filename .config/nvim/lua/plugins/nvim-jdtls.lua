return {
  {"mfussenegger/nvim-jdtls",
    ft = "java",
    config = function()
      -- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v2.x/doc/md/guides/setup-with-nvim-jdtls.md
      local java_cmds = vim.api.nvim_create_augroup('java_cmds', { clear = true })

      local root_files = {
        '.git',
        'mvnw',
        'gradelw',
        'pom.xml',
        'build.gradle',
      }

      local jdtls_capabilities = {}

      local jdtls_paths = false

      local function get_jdtls_paths()
        if jdtls_paths then
          return jdtls_paths
        end

        local path = {}

        path.data_dir = vim.fn.stdpath('cache') .. '/nvim-jdtls'

        local jdtls_install = require('mason-registry')
            .get_package('jdtls')
            :get_install_path()

        path.java_agent = jdtls_install .. '/lombok.jar'
        path.launcher_jar = vim.fn.glob(jdtls_install .. '/plugins/org.eclipse.equinox.launcher_*.jar')

        path.platform_config = jdtls_install .. '/config_linux'

        jdtls_paths = path

        return path
      end

      local function enable_codelens(bufnr)
        pcall(vim.lsp.codelens.refresh)

        vim.api.nvim_create_autocmd('BufWritePost', {
          buffer = bufnr,
          group = java_cmds,
          desc = 'refresh codelens',
          callback = function()
            pcall(vim.lsp.codelens.refresh)
          end,
        })
      end

      local function jdtls_on_attach(client, bufnr)
        local lsp = require('lsp-zero')

        -- enable_codelens(bufnr)
        local opts = { buffer = bufnr }

        lsp.default_keymaps(opts)
        vim.keymap.set('n', '<A-o>', "<cmd>lua require('jdtls').organize_imports()<cr>", opts)
        vim.keymap.set('n', 'crv', "<cmd>lua require('jdtls').extract_variable()<cr>", opts)
        vim.keymap.set('x', 'crv', "<esc><cmd>lua require('jdtls').extract_variable(true)<cr>", opts)
        vim.keymap.set('n', 'crc', "<cmd>lua require('jdtls').extract_constant()<cr>", opts)
        vim.keymap.set('x', 'crc', "<esc><cmd>lua require('jdtls').extract_constant(true)<cr>", opts)
        vim.keymap.set('x', 'crm', "<esc><cmd>lua require('jdtls').extract_method(true)<cr>", opts)
      end

      local function jdtls_setup(event)
        local jdtls = require('jdtls')

        jdtls.extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

        local path = get_jdtls_paths()
        local data_dir = path.data_dir .. '/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
        local bundles = {}

        local cmd = {
          -- 💀
          'java',

          '-Declipse.application=org.eclipse.jdt.ls.core.id1',
          '-Dosgi.bundles.defaultStartLevel=4',
          '-Declipse.product=org.eclipse.jdt.ls.core.product',
          '-Dlog.protocol=true',
          '-Dlog.level=ALL',
          '-javaagent:' .. path.java_agent,
          '-Xms1g',
          '--add-modules=ALL-SYSTEM',
          '--add-opens',
          'java.base/java.util=ALL-UNNAMED',
          '--add-opens',
          'java.base/java.lang=ALL-UNNAMED',
          
          -- 💀
          '-jar',
          path.launcher_jar,

          -- 💀
          '-configuration',
          path.platform_config,

          -- 💀
          '-data',
          data_dir,
        }

        local lsp_settings = {
          java = {
            eclipse = {
              downloadSources = true,
            },
            configuration = {
              updateBuildConfiguration = 'interactive',
              runtimes = path.runtimes,
            },
            maven = {
              downloadSources = true,
            },
            implementationCodeLens = {
              enabled = true,
            },
            referencesCodeLens = {
              enabled = true,
            },
            format = {
              enabled = true,
            }
          },
          signatureHelp = {
            enabled = true,
          },
          completion = {
            favoriteStaticMembers = {
              'org.hamcrest.MatcherAssert.assertThat',
              'org.hamcrest.Matchers.*',
              'org.hamcrest.CoreMatchers.*',
              'org.junit.jupiter.api.Assertions.*',
              'java.util.Objects.requireNonNull',
              'java.util.Objects.requireNonNullElse',
              'org.mockito.Mockito.*',
            },
          },
          contentProvider = {
            preferred = 'fernflower',
          },
          extendedClientCapabilities = jdtls.extendedClientCapabilities,
          sources = {
            organizeImports = {
              starThreshold = 9999,
              staticStarThreshold = 9999,
            }
          },
          codeGeneration = {
            toString = {
              template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}',
            },
            useBlocks = true,
          },
        }

        if vim.tbl_isempty(jdtls_capabilities) then
          local ok_cmp, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
          jdtls_capabilities = vim.tbl_deep_extend(
            'force',
            vim.lsp.protocol.make_client_capabilities(),
            ok_cmp and cmp_lsp.default_capabilities() or {}
          )
        end

        jdtls.start_or_attach({
          cmd = cmd,
          settings = lsp_settings,
          on_attach = jdtls_on_attach,
          capabilities = jdtls_capabilities,
          root_dir = jdtls.setup.find_root(root_files),
          flags = {
            allow_incremental_sync = true,
          },
          init_options = {
            bundles = bundles,
          },
        })
      end

      vim.api.nvim_create_autocmd('FileType', {
        group = java_cmds,
        pattern = { 'java' },
        desc = 'Setup jdtls',
        callback = jdtls_setup,
      })
          end
  },
}

