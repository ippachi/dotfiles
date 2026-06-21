vim.api.nvim_create_autocmd("CmdlineChanged", {
  pattern = { ":", "/", "?" },
  callback = function()
    vim.fn.wildtrigger()
  end,
})

vim.opt.wildmode = { "noselect:lastused", "full" }
vim.opt.wildoptions = { "pum" }

vim.keymap.set("c", "<Up>", function()
  return vim.fn.wildmenumode() == 1 and "<C-E><Up>" or "<Up>"
end, { expr = true })

vim.keymap.set("c", "<Down>", function()
  return vim.fn.wildmenumode() == 1 and "<C-E><Down>" or "<Down>"
end, { expr = true })
