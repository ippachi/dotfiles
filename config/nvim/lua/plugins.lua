require("packer").startup(function(use)
  use("wbthomason/packer.nvim")
  use("ntpeters/vim-better-whitespace")
  use({ "rebelot/kanagawa.nvim", config = "vim.cmd[[colorscheme kanagawa]]" })
  use({ "machakann/vim-sandwich", keys = "sr" })
  use({
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map("n", "]c", function()
            if vim.wo.diff then
              return "]c"
            end
            vim.schedule(function()
              gs.next_hunk()
            end)
            return "<Ignore>"
          end, { expr = true })

          map("n", "[c", function()
            if vim.wo.diff then
              return "[c"
            end
            vim.schedule(function()
              gs.prev_hunk()
            end)
            return "<Ignore>"
          end, { expr = true })

          -- Actions
          map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>")
          map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>")
          map("n", "<leader>hS", gs.stage_buffer)
          map("n", "<leader>hu", gs.undo_stage_hunk)
          map("n", "<leader>hR", gs.reset_buffer)
          map("n", "<leader>hp", gs.preview_hunk)
          map("n", "<leader>hb", function()
            gs.blame_line({ full = true })
          end)
          map("n", "<leader>tb", gs.toggle_current_line_blame)
          map("n", "<leader>hd", gs.diffthis)
          map("n", "<leader>hD", function()
            gs.diffthis("~")
          end)
          map("n", "<leader>td", gs.toggle_deleted)

          -- Text object
          map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
        end,
      })
    end,
  })
  use({
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        highlight = {
          enable = true,
        },
      })
    end,
  })
  use({
    "nvim-lualine/lualine.nvim",
    requires = { "kyazdani42/nvim-web-devicons" },
    config = function()
      require("lualine").setup({})
    end,
  })
  use("lukas-reineke/indent-blankline.nvim")
  use({
    "neovim/nvim-lspconfig",
    requires = {
      { "folke/neodev.nvim" },
      { "williamboman/mason.nvim" },
      { "williamboman/mason-lspconfig.nvim" },
      { "hrsh7th/cmp-nvim-lsp" },
    },
    config = function()
      require("neodev").setup()
      require("mason").setup()
      require("mason-lspconfig").setup()

      local on_attach = function(client, bufnr)
        vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

        local bufopts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
        vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
        vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
        vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
        vim.keymap.set("n", "<leader>wl", function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, bufopts)
        vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, bufopts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
        vim.keymap.set("n", "<leader>f", function()
          vim.lsp.buf.format({ async = true })
        end, bufopts)
      end

      local util = require("lspconfig.util")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      require("lspconfig")["sorbet"].setup({
        cmd = {
          "bundle",
          "exec",
          "srb",
          "tc",
          "--lsp",
          "--enable-all-experimental-lsp-features",
          "--disable-watchman",
        },
        root_dir = util.root_pattern("sorbet/config"),
        on_attach = on_attach,
        capabilities = capabilities,
      })
      require("lspconfig")["terraformls"].setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })
      require("lspconfig")["tsserver"].setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })
      require("lspconfig")["solargraph"].setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })
      require("lspconfig")["ruby_ls"].setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })
      require("lspconfig")["yamlls"].setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })
      require("lspconfig")["eslint"].setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          format = true,
        },
      })
      require("lspconfig")["sumneko_lua"].setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          Lua = {
            workspace = {
              -- Make the server aware of Neovim runtime files
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
          },
        },
      })
    end,
  })

  use({
    {
      "RRethy/nvim-treesitter-endwise",
      ft = { "ruby", "lua" },
      config = function()
        require("nvim-treesitter.configs").setup({
          endwise = {
            enable = true,
          },
        })
      end,
    },
    "nvim-treesitter/nvim-treesitter-context",
    {
      "nvim-treesitter/playground",
      cmd = "TSPlaygroundToggle",
    },
  })
  use({
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup({})
    end,
    event = "InsertEnter",
  })
  use({
    "tpope/vim-fugitive",
    setup = function()
      vim.keymap.set("n", "<leader>g", "<cmd>tab Git<cr>")
    end,
    cmd = "Git",
  })
  use({
    "AndrewRadev/linediff.vim",
    cmd = "Linediff",
  })
  use({
    "hrsh7th/nvim-cmp",
    requires = {
      { "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" },
      { "hrsh7th/cmp-buffer", after = "nvim-cmp" },
      { "hrsh7th/cmp-path", after = "nvim-cmp" },
      { "hrsh7th/cmp-cmdline", after = "nvim-cmp" },
      { "hrsh7th/cmp-vsnip", after = "nvim-cmp" },
      { "hrsh7th/vim-vsnip", after = "nvim-cmp" },
      { "hrsh7th/cmp-emoji", after = "nvim-cmp" },
    },
    event = { "InsertEnter", "CmdlineEnter" },
    config = function()
      local cmp = require("cmp")

      cmp.setup({
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<C-y>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "vsnip" }, -- For vsnip users.
        }, { { name = "emoji" } }, {
          { name = "buffer" },
        }),
      })

      -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })
    end,
  })

  use({
    {
      "nvim-telescope/telescope.nvim",
      tag = "0.1.0",
      requires = { "nvim-lua/plenary.nvim" },
      setup = function()
        vim.keymap.set("n", "<c-p>", "<cmd>Telescope find_files<cr>")
        vim.keymap.set("n", "<space>r", "<cmd>Telescope resume<cr>")
        vim.api.nvim_create_user_command("Grep", "Telescope live_grep", { force = true })
      end,
      cmd = { "Telescope" },
      config = function()
        require("telescope").setup({
          extensions = {
            fzf = {
              fuzzy = false,
              override_generic_sorter = true,
              override_file_sorter = true,
              case_mode = "smart_case",
            },
          },
        })
      end,
    },
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      run = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
      config = function()
        require("telescope").load_extension("fzf")
      end,
      after = "telescope.nvim",
    },
  })

  use({
    "vimwiki/vimwiki",
    requires = { "junegunn/fzf", "junegunn/fzf.vim" },
    setup = function()
      vim.g.vimwiki_list = {
        {
          path = "~/Documents/private/wiki/",
          ext = ".md",
          syntax = "markdown",
          template_path = "~/Documents/private/wiki/templates",
          template_default = "def_template",
          template_ext = ".md",
        },
      }
      vim.keymap.set("n", "<leader>ww", "<cmd>VimwikiIndex<cr>")
    end,
    cmd = "VimwikiIndex",
  })

  use({
    "jose-elias-alvarez/null-ls.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.formatting.rubocop,
        },
      })
    end,
  })

  use({
    "nvim-tree/nvim-tree.lua",
    requires = {
      "nvim-tree/nvim-web-devicons",
    },
    setup = function()
      vim.keymap.set("n", "<space>f", "<cmd>NvimTreeFindFileToggle<cr>")
    end,
    cmd = "NvimTreeFindFileToggle",
    tag = "nightly", -- optional, updated every week. (see issue #1193)
    config = function()
      require("nvim-tree").setup({
        actions = {
          open_file = {
            quit_on_open = true,
          },
        },
      })
    end,
  })
  use({
    "akinsho/git-conflict.nvim",
    tag = "*",
    config = function()
      require("git-conflict").setup({
        default_mappings = false,
        disable_diagnostics = true,
        highlights = {
          incoming = "DiffText",
          current = "DiffAdd",
        },
      })
    end,
  })
  use({
    "glepnir/lspsaga.nvim",
    branch = "main",
    cmd = "Lspsaga",
    setup = function()
      local keymap = vim.keymap.set
      keymap({ "n", "v" }, "<leader>ca", "<cmd>Lspsaga code_action<CR>", { silent = true })
      keymap("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", { silent = true })
      keymap("n", "gd", "<cmd>Lspsaga peek_definition<CR>", { silent = true })
      keymap("n", "<leader>e", "<cmd>Lspsaga show_line_diagnostics<CR>", { silent = true })
      keymap("n", "<leader>e", "<cmd>Lspsaga show_cursor_diagnostics<CR>", { silent = true })
      keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>", { silent = true })
    end,
    config = function()
      local saga = require("lspsaga")

      saga.init_lsp_saga()
    end,
  })
  use({
    "pwntester/octo.nvim",
    wants = {
      "plenary.nvim",
      "telescope.nvim",
      "nvim-web-devicons",
    },
    cmd = "Octo",
    config = function()
      require("octo").setup()
    end,
  })
  use({
    "sindrets/diffview.nvim",
    requires = "nvim-lua/plenary.nvim",
    cmd = "DiffviewOpen",
  })
  use({
    "gen740/SmoothCursor.nvim",
    config = function()
      require("smoothcursor").setup()
    end,
  })
  use({
    "iamcco/markdown-preview.nvim",
    run = function()
      vim.fn["mkdp#util#install"]()
    end,
    ft = { "vimwiki", "markdown" },
  })
  use({
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup({})
    end,
  })
  use({
    "tversteeg/registers.nvim",
    config = function()
      require("registers").setup()
    end,
  })
end)
