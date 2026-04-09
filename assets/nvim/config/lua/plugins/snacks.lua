return {
	{
		"folke/snacks.nvim",
		keys = {
			{
				"<leader>E",
				function()
					Snacks.explorer()
				end,
				desc = "File Explorer",
			},
		},
		opts = {
			image = {
				enabled = true,
			},
			statuscolumn = {
				enabled = true,
			},
		},
	},
}
