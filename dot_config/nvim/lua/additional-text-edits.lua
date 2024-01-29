local function get_completion_item()
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
	local responses, err = vim.lsp.buf_request_sync(0, "completionItem/resolve", completion_item, 500)
	if err ~= nil then
		print(err)
		return nil
	end

	return responses
end

local function apply_additional_text_edits_by_client_id(client_id, res)
	local client = vim.lsp.get_client_by_id(client_id)
	vim.lsp.util.apply_text_edits(res.result.additionalTextEdits, 0, client.offset_encoding)
end

local function apply_additional_text_edits()
	local completion_item = get_completion_item()
	if completion_item == nil then
		return
	end

	local responses = resolve_completion_item(completion_item)
	if responses == nil then
		return
	end

	for client_id, res in ipairs(responses) do
		if res.error == nil and res.result.additionalTextEdits ~= nil then
			apply_additional_text_edits_by_client_id(client_id, res)
		end
	end
end

vim.api.nvim_create_user_command("ApplyAdditionalTextEdits", function()
	apply_additional_text_edits()
end, {})
