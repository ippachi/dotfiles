local keymap = vim.keymap
local api = vim.api
local augroup = api.nvim_create_augroup("my-vimrc", { clear = true })

vim.opt.autoindent = true
vim.opt.smartindent = true

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.backupdir = vim.env.HOME .. "/.config/nvim/backup/"

vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.pumheight = 10

vim.opt.number = true
vim.opt.signcolumn = "number"

vim.opt.cmdheight = 2
vim.opt.title = true
vim.opt.undofile = true
vim.opt.mouse = ""
vim.opt.formatoptions:append({
	t = true,
	m = true,
	M = true,
})
vim.opt.diffopt = { "internal", "filler", "algorithm:histogram", "indent-heuristic", "linematch:60" }
vim.opt.updatetime = 300
vim.opt.completeopt = { "menu", "menuone", "noselect" }

vim.cmd([[packadd Cfilter]])

vim.g.mapleader = ","

keymap.set("n", "j", "gj", { noremap = true })
keymap.set("n", "k", "gk", { noremap = true })
keymap.set("t", "<c-o>", "<c-\\><c-n>", { noremap = true })

vim.api.nvim_create_autocmd("QuickFixcmdPost", {
	group = augroup,
	pattern = { "grep", "vimgrep" },
	callback = function()
		vim.cmd([[cwindow]])
	end,
})

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{
		"sainnhe/gruvbox-material",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd([[colorscheme gruvbox-material]])
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		event = "BufReadPre",
		config = function()
			require("gitsigns").setup({
				on_attach = function(bufnr)
					local gs = package.loaded.gitsigns
					local function map(mode, l, r, opts)
						opts = opts or {}
						opts.buffer = bufnr
						vim.keymap.set(mode, l, r, opts)
					end

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
				end,
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"RRethy/nvim-treesitter-endwise",
		},
		build = ":TSUpdate",
		event = "BufReadPre",
		config = function()
			require("nvim-treesitter.configs").setup({
				highlight = {
					enable = true,
					disable = { "embedded_template" },
				},
				endwise = { enable = true },
			})
		end,
	},
	{ "itchyny/vim-qfedit", event = "QuickFixCmdPost" },
	{
		"echasnovski/mini.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		version = false,
		config = function()
			require("mini.pairs").setup()
			require("mini.comment").setup()
			require("mini.surround").setup()
			require("mini.trailspace").setup()
			require("mini.statusline").setup()
			require("mini.files").setup()
			require("mini.ai").setup()
			require("mini.hipatterns").setup()
			require("mini.indentscope").setup()
			require("mini.extra").setup()
			require("mini.pick").setup({
				mappings = {
					choose_marked = "<C-q>",
				},
			})

			vim.keymap.set("n", "<c-p>", function()
				MiniPick.builtin.files()
			end, { noremap = true })
			vim.keymap.set("n", "<c-h>", function()
				MiniPick.builtin.help()
			end, { noremap = true })
			vim.keymap.set("n", "<space>f", function()
				MiniFiles.open(vim.api.nvim_buf_get_name(0))
			end, { noremap = true })
			vim.api.nvim_create_user_command("Buffers", function()
				MiniPick.builtin.buffers()
			end, {})
			vim.api.nvim_create_user_command("Grep", function()
				MiniPick.builtin.grep_live()
			end, {})

			vim.ui.select = MiniPick.ui_select
		end,
	},
	{ "tpope/vim-fugitive", cmd = "Git" },
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
			"folke/neodev.nvim",
		},
		event = "BufReadPre",
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup()
			require("neodev").setup()

			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			require("mason-lspconfig").setup_handlers({
				function(server_name)
					require("lspconfig")[server_name].setup({
						capabilities = capabilities,
					})
				end,

				["tsserver"] = function()
					require("lspconfig")["tsserver"].setup({
						on_attach = function()
							vim.api.nvim_create_user_command("OR", function()
								vim.lsp.buf.execute_command({
									command = "_typescript.organizeImports",
									arguments = { vim.api.nvim_buf_get_name(0) },
								})
							end, { desc = "Organize Imports" })
						end,
						capabilities = capabilities,
					})
				end,

				["ruby_ls"] = function()
					require("lspconfig")["ruby_ls"].setup({
						init_options = {
							formatter = false,
							featuresConfiguration = {
								inlayHint = {
									enableAll = true,
								},
							},
						},
					})
				end,
			})

			vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

					local opts = { buffer = ev.buf }
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
					vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
					vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
					vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
					vim.keymap.set("n", "<leader>wl", function()
						print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
					end, opts)
					vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
					vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
					vim.keymap.set("n", "<leader>f", function()
						vim.lsp.buf.format({ async = true })
					end, opts)
				end,
			})
		end,
	},
	{ "j-hui/fidget.nvim", dependencies = { "neovim/nvim-lspconfig" }, config = true, event = "LspAttach" },
	{
		"stevearc/conform.nvim",
		event = "BufReadPre",
		opts = {
			notify_on_error = false,
			formatters_by_ft = {
				lua = { "stylua" },
				typescriptreact = { { "prettierd", "prettier" } },
				typescript = { { "prettierd", "prettier" } },
			},
			format_on_save = {
				timeout_ms = 500,
				lsp_fallback = true,
			},
		},
	},
	{
		"sindrets/diffview.nvim",
		cmd = "DiffviewOpen",
		init = function()
			vim.api.nvim_create_user_command("DO", "DiffviewOpen", {})
		end,
		opts = {
			keymaps = {
				file_panel = {
					{
						"n",
						"cc",
						"<Cmd>Git commit <bar> wincmd J<CR>",
						{ desc = "Commit staged changes" },
					},
					{
						"n",
						"ca",
						"<Cmd>Git commit --amend <bar> wincmd J<CR>",
						{ desc = "Amend the last commit" },
					},
					{
						"n",
						"c<space>",
						":Git commit ",
						{ desc = 'Populate command line with ":Git commit "' },
					},
				},
			},
		},
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-vsnip",
			"hrsh7th/vim-vsnip",
		},
		event = "InsertEnter",
		config = function()
			local cmp = require("cmp")

			cmp.setup({
				snippet = {
					-- REQUIRED - you must specify a snippet engine
					expand = function(args)
						vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
						-- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
						-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
						-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-l>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<C-y>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "vsnip" }, -- For vsnip users.
					-- { name = 'luasnip' }, -- For luasnip users.
					-- { name = 'ultisnips' }, -- For ultisnips users.
					-- { name = 'snippy' }, -- For snippy users.
				}, {
					{ name = "buffer" },
				}),
			})
		end,
	},
})
