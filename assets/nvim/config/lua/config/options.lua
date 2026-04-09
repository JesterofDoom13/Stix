-- vim.cmd("colorscheme " .. nixCats.cats.colorscheme.btylixj
vim.cmd("let base16colorspace=256")
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
---@diagnostic disable-next-line: duplicate-set-field
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
	opts = opts or {}
	opts.border = "rounded" -- Or any other border
	return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

-- vim.lsp.buf.hover() and any other windows like this one should have the border that you choosed above
