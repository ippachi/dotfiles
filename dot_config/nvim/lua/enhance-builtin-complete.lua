local function get_completion_item_and_client()
	local result, err_or_result = pcall(function()
		return vim.v.completed_item.user_data.nvim.lsp.completion_item
	end)

	if result == false then
		local is_expected_error = type(err_or_result) == "string"
			and string.find(err_or_result, "attempt to index .* %(a nil value%)")

		if not is_expected_error then
			error(err_or_result)
		end

		return nil
	end

	return err_or_result
end

local function resolve_completion_item(completion_item)
	local results = {}
  vim.print(#vim.lsp.get_clients({ bufnr = 0, method = "completionItem/resolve" }))
	for _, client in pairs(vim.lsp.get_clients({ bufnr = 0, method = "completionItem/resolve" })) do
		local result = client.request_sync("completionItem/resolve", completion_item, 500, 0)
		if result ~= nil and result ~= "timeout" and result.err == nil then
			table.insert(results, result)
		end
	end

	return results
end

local function apply_additional_text_edits_by_client_id(client_id, res)
	local client = vim.lsp.get_client_by_id(client_id)
	vim.lsp.util.apply_text_edits(res.result.additionalTextEdits, vim.fn.bufnr(), client.offset_encoding)
end

local function expand_snippet(text)
  local row = vim.fn.line(".")
	local completion_start = vim.fn.col(".") - #vim.v.completed_item.word
	local completion_end = vim.fn.col(".")
  vim.api.nvim_buf_set_text(0, row - 1, completion_start - 1, row - 1, completion_end - 1, {})
	vim.snippet.expand(text)
end

local function resolve_lsp_completion_item()
	local completion_item = get_completion_item_and_client()

	if completion_item == nil then
		return
	end

  if completion_item.textEdit ~= nil and completion_item.insertTextFormat == 2 then
    expand_snippet(completion_item.textEdit.newText)
    return
  end

	local responses = resolve_completion_item(completion_item)

	for client_id, res in ipairs(responses) do
		if res.result.additionalTextEdits ~= nil then
			apply_additional_text_edits_by_client_id(client_id, res)
		end

		if res.result.insertText ~= nil and res.result.insertTextFormat == 2 then
			expand_snippet(res.result.insertText)
		end

	end
end

vim.api.nvim_create_user_command("ResolveCompletionItem", function()
	resolve_lsp_completion_item()
end, {})
