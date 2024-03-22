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
vim.opt.completeopt = { "menu", "menuone", "noselect", "popup" }
vim.opt.exrc = true

vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.breakindentopt = "shift:2,sbr"
vim.opt.breakat:remove(":@!")
vim.opt.showbreak = "\\"

vim.opt.grepprg = "rg --pcre2 --vimgrep"
vim.opt.grepformat:prepend("%f:%l:%c:%m")

vim.cmd([[packadd Cfilter]])

vim.g.mapleader = ","

keymap.set("n", "j", "gj", { noremap = true })
keymap.set("n", "k", "gk", { noremap = true })
keymap.set("n", "\\", ",", { noremap = true })
keymap.set("t", "<c-o>", "<c-\\><c-n>", { noremap = true })
keymap.set("n", "<leader>gg", function()
	return ":silent grep ''<Left>"
end, { noremap = true, expr = true })

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
		"rebelot/kanagawa.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd([[colorscheme kanagawa]])
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
			require("mini.ai").setup()
			require("mini.hipatterns").setup()
			require("mini.indentscope").setup()
			require("mini.extra").setup()
			require("mini.align").setup()
		end,
	},
	{ "tpope/vim-fugitive", cmd = "Git" },
	{
		"sindrets/diffview.nvim",
		opts = {
			view = {
				merge_tool = {
					layout = "diff3_mixed",
				},
			},
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
		"j-hui/fidget.nvim",
		config = function()
			require("fidget").setup()
			vim.notify = require("fidget.notification").notify
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"j-hui/fidget.nvim",
			"b0o/schemastore.nvim",
			"folke/neodev.nvim",
		},
		config = function()
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities.textDocument.completion.completionItem.snippetSupport = true

			require("neodev").setup()
			require("mason").setup()
			require("mason-lspconfig").setup()
			require("mason-lspconfig").setup_handlers({
				-- The first entry (without a key) will be the default handler
				-- and will be called for each installed server that doesn't have
				-- a dedicated handler.
				function(server_name) -- default handler (optional)
					if server_name == "rubocop" then
						return
					elseif server_name == "jsonls" then
						require("lspconfig")[server_name].setup({
							settings = {
								json = {
									schemas = require("schemastore").json.schemas(),
									validate = { enable = true },
								},
							},
							capabilities = capabilities,
						})
					elseif server_name == "yamlls" then
						require("lspconfig")[server_name].setup({
							settings = {
								yaml = {
									schemaStore = {
										-- You must disable built-in schemaStore support if you want to use
										-- this plugin and its advanced options like `ignore`.
										enable = false,
										-- Avoid TypeError: Cannot read properties of undefined (reading 'length')
										url = "",
									},
									schemas = require("schemastore").yaml.schemas(),
								},
							},
							capabilities = capabilities,
						})
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
			lspconfig.sourcekit.setup({})

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
					vim.keymap.set("n", "<leader>f", function()
						vim.lsp.buf.format({ async = true })
					end, opts)

					vim.api.nvim_create_user_command("OR", function()
						vim.lsp.buf.execute_command({
							command = "_typescript.organizeImports",
							arguments = { vim.fn.expand("%:p") },
						})
					end, {})

					require("enhance-builtin-complete")
					vim.keymap.set("i", "<C-y>", "<C-y><Cmd>ResolveCompletionItem<CR>", { noremap = true })
				end,
			})
		end,
	},
	-- {
	-- 	"stevearc/conform.nvim",
	-- 	config = function()
	-- 		require("conform").setup({
	-- 			formatters_by_ft = {
	-- 				lua = { "stylua" },
	-- 				ruby = { "rubocop" },
	-- 				typescriptreact = { { "prettierd", "prettier" } },
	-- 				typescript = { { "prettierd", "prettier" } },
	-- 			},
	-- 			notify_on_error = false,
	-- 		})
	-- 		vim.keymap.set("n", "<leader>f", function()
	-- 			require("conform").format({ lsp_fallback = true })
	-- 		end, {})
	-- 	end,
	-- },
	-- {
	-- 	"mfussenegger/nvim-lint",
	-- 	config = function()
	-- 		local lint = require("lint")
	-- 		lint.linters_by_ft = {
	-- 			ruby = { "rubocop" },
	-- 		}
	-- 		vim.api.nvim_create_autocmd({ "TextChanged", "BufReadPost", "BufWritePost" }, {
	-- 			callback = function()
	-- 				lint.try_lint()
	-- 			end,
	-- 		})
	-- 	end,
	-- },
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
	{
		dir = "~/ghq/github.com/ippachi/nvim-script-runner",
		dependencies = { "j-hui/fidget.nvim" },
		config = function()
			local script_runner = require("nvim-script-runner").setup({
				presets = {
					["bin/rails"] = {
						function()
							return "bin/rails test " .. vim.fn.expand("%") .. ":" .. vim.fn.line(".")
						end,
						function()
							return "env -u VIM bin/rails test " .. vim.fn.expand("%")
						end,
						function()
							return "bin/rails test"
						end,
						function()
							return "bin/rails test:system"
						end,
					},
					["rspec"] = {
						function()
							return "bundle exec rspec " .. vim.fn.expand("%") .. ":" .. vim.fn.line(".")
						end,
						function()
							return "bundle exec rspec " .. vim.fn.expand("%")
						end,
						function()
							return "bundle exec rspec"
						end,
					},
				},
			})

			vim.keymap.set("n", "<leader>tt", function()
				script_runner.run_preset(1)
			end, { noremap = true })
			vim.keymap.set("n", "<leader>tf", function()
				script_runner.run_preset(2)
			end, { noremap = true })
			vim.keymap.set("n", "<leader>ta", function()
				script_runner.run_preset(3)
			end, { noremap = true })
			vim.keymap.set("n", "<leader>tl", function()
				script_runner.run_last()
			end, { noremap = true })
			vim.keymap.set("n", "<leader>to", function()
				script_runner.open_output()
			end, { noremap = true })
			vim.api.nvim_create_user_command("SetScriptRunnerPreset", function()
				script_runner.set_preset()
			end, {})
			vim.api.nvim_create_user_command("SR", function(opts)
				script_runner.run(opts.args)
			end, { nargs = 1 })
		end,
	},
	{
		"stevearc/dressing.nvim",
		opts = {},
	},
	{
		"stevearc/oil.nvim",
		init = function()
			vim.keymap.set("n", "-", "<Cmd>Oil<CR>", { noremap = true })
		end,
		opts = {},
	},
	{
		"kana/vim-altr",
		init = function()
			vim.keymap.set("n", "]t", "<Plug>(altr-forward)", {})
			vim.keymap.set("n", "[t", "<Plug>(altr-back)", {})
		end,
		config = function()
			vim.fn["altr#remove_all"]()
			vim.fn["altr#define"](
				"app/models/%.rb",
				"spec/models/%_spec.rb",
				"spec/factories/%s.rb",
				"test/models/%_test.rb",
				"test/factories/%s.rb"
			)
			vim.fn["altr#define"]("app/jobs/%.rb", "spec/jobs/%_spec.rb", "test/jobs/%_test.rb")
			vim.fn["altr#define"](
				"app/controllers/%_controller.rb",
				"spec/controllers/%_controller_spec.rb",
				"test/controllers/%_controller_test.rb"
			)
			vim.fn["altr#define"]("%.tsx", "%.stories.tsx")
		end,
	},
	{
		"wojciech-kulik/xcodebuild.nvim",
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-lua/plenary.nvim",
		},
		opts = {},
	},
	{
		"tpope/vim-rails",
	},
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		init = function()
			vim.keymap.set("n", "<C-p>", function()
				require("telescope.builtin").find_files()
			end, { noremap = true })
		end,
		config = function()
			local actions = require("telescope.actions")
			local finders = require("telescope.finders")
			local pickers = require("telescope.pickers")
			local conf = require("telescope.config").values

			local rails_search = function(opts)
				opts = opts or {}

				local rails_dirs = {
					"models",
					"controllers",
					"views",
					"javascript",
					"helpers",
					"jobs",
					"mailers",
				}

				pickers
					.new(opts, {
						prompt_title = "Search Rails",
						finder = finders.new_table({
							results = rails_dirs,
						}),
						sorter = conf.generic_sorter(opts),

						-- 選択されたディレクトリに対するアクション
						attach_mappings = function(prompt_bufnr, map)
							actions.select_default:replace(function()
								actions.close(prompt_bufnr)
								local selection = require("telescope.actions.state").get_selected_entry()
								local search_dir = "app/" .. selection[1] -- 選択されたディレクトリへのパス
								require("telescope.builtin").find_files({ cwd = search_dir })
							end)
							return true
						end,
					})
					:find()
			end
			vim.keymap.set("n", "<leader>p", function()
				rails_search()
			end, { noremap = true })
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {},
	},
	{
		"nvimtools/none-ls.nvim",
		config = function()
			local null_ls = require("null-ls")
			null_ls.setup({
				sources = {
					null_ls.builtins.formatting.rubocop,
					null_ls.builtins.diagnostics.rubocop,

					null_ls.builtins.formatting.prettierd,

					null_ls.builtins.formatting.stylua,
				},
			})
		end,
	},
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
	},
})
