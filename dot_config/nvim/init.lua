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

vim.cmd([[cabbr t tab]])
vim.cmd([[cabbr tt tab terminal]])
for _, keycode in pairs({
	"<C-x><C-n>",
	"<C-x><C-p>",
	"<C-n>",
	"<C-p>",
}) do
	keymap.set("i", keycode, function()
		vim.opt.completeopt = { "menu", "menuone" }
		return keycode
	end, { noremap = true, expr = true })
end

vim.api.nvim_create_autocmd("CompleteDone", {
	group = augroup,
	pattern = { "*" },
	callback = function()
		vim.opt.completeopt = { "menu", "menuone", "noselect" }
	end,
})

vim.api.nvim_create_autocmd("QuickFixcmdPost", {
	group = augroup,
	pattern = { "grep", "vimgrep" },
	callback = function()
		vim.cmd([[cwindow]])
	end,
})

vim.api.nvim_create_autocmd("TermOpen", {
	group = augroup,
	pattern = { "*" },
	command = "startinsert",
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
			"windwp/nvim-ts-autotag",
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
				autotag = {
					enable = true,
				},
				endwise = {
					enable = true,
				},
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
			require("mini.comment").setup()
			require("mini.surround").setup()
			require("mini.trailspace").setup()
			require("mini.statusline").setup()
			require("mini.files").setup()
			require("mini.pairs").setup()
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
			vim.api.nvim_create_user_command("Registers", function()
				MiniExtra.pickers.registers()
			end, {})
		end,
	},
	{ "tpope/vim-fugitive", cmd = "Git" },
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
		"AndrewRadev/linediff.vim",
		cmd = "Linediff",
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"j-hui/fidget.nvim",
		},
		config = function()
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities.textDocument.completion.completionItem.snippetSupport = true

			require("fidget").setup()
			require("mason").setup()
			require("mason-lspconfig").setup()
			require("mason-lspconfig").setup_handlers({
				-- The first entry (without a key) will be the default handler
				-- and will be called for each installed server that doesn't have
				-- a dedicated handler.
				function(server_name) -- default handler (optional)
					if server_name == "rubocop" then
						return
					else
						require("lspconfig")[server_name].setup({
							capabilities = capabilities,
						})
					end
				end,
				-- Next, you can provide a dedicated handler for specific servers.
				-- For example, a handler override for the `rust_analyzer`:
				-- ["rust_analyzer"] = function ()
				--     require("rust-tools").setup {}
				-- end
			})

			local lspconfig = require("lspconfig")

			vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
			vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
			vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
			vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					-- Enable completion triggered by <c-x><c-o>
					vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

					-- Buffer local mappings.
					-- See `:help vim.lsp.*` for documentation on any of the below functions
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

					vim.api.nvim_create_user_command("OR", function()
						vim.lsp.buf.execute_command({
							command = "_typescript.organizeImports",
							arguments = { vim.fn.expand("%:p") },
						})
					end, {})

					require("additional-text-edits")
					vim.keymap.set("i", "<C-y>", "<C-y><Cmd>ApplyAdditionalTextEdits<CR>", { noremap = true })
				end,
			})
		end,
	},
	{
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					ruby = { "rubocop" },
					typescriptreact = { { "prettierd", "prettier" } },
					typescript = { { "prettierd", "prettier" } },
				},
				format_on_save = {
					timeout_ms = 500,
					lsp_fallback = true,
				},
			})
			vim.keymap.set("n", "<leader>f", function()
				require("conform").format({ lsp_fallback = true })
			end, {})
		end,
	},
	{
		"mfussenegger/nvim-lint",
		config = function()
			local lint = require("lint")
			lint.linters_by_ft = {
				ruby = { "rubocop" },
			}
			vim.api.nvim_create_autocmd({ "TextChanged", "BufReadPost", "BufWritePost" }, {
				callback = function()
					lint.try_lint()
				end,
			})
		end,
	},
	{
		"nvimdev/template.nvim",
		cmd = { "Template", "TemProject" },
		opts = {
			temp_dir = "~/.config/nvim/templates",
		},
	},
	{
		"github/copilot.vim",
	},
	{
		"rbong/vim-flog",
		lazy = true,
		cmd = { "Flog", "Flogsplit", "Floggit" },
		dependencies = {
			"tpope/vim-fugitive",
		},
	},
})
