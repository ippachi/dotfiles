vim.opt.iskeyword:append({ "?" })

local function grep(pattern, placeholder_count)
	local array = {}
	local cword = vim.fn.expand("<cword>"):gsub("%?", "\\?")
	for _ = 1, placeholder_count do
		table.insert(array, cword)
	end

	pattern = pattern:gsub("^%s*(.-)%s*$", "%1"):gsub("\n", "")
	vim.cmd(string.format(pattern, unpack(array)))
end

vim.keymap.set("n", "<leader>gm", function()
	grep(
		[[
silent grep '^
(\s*def (self\.)?%s(\(\| \|$))\|
(\s*(scope\|has_many\|has_one\|belongs_to) :%s(,\|$))
'
]],
		2
	)
end, { noremap = true, silent = true })

vim.keymap.set("n", "<leader>gc", function()
	grep(
		[[
silent grep '^
\s*(class\|module)( \|.+::)%s( <.*)?
$'
]],
		1
	)
end, { noremap = true, silent = true })
