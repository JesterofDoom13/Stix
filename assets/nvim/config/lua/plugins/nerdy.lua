return {
	"2kabhishek/nerdy.nvim",
	dependencies = {
		"folke/snacks.nvim",
	},
	keys = {
		{ "<leader>sN", "<cmd>Nerdy<cr>", { desc = "Search Nerdy icons", icon = "󰊪 " } },
	},
	cmd = "Nerdy",
	opts = {
		max_recents = 30, -- Configure recent icons limit
		add_default_keybindings = true, -- Add default keybindings
		copy_to_clipboard = true, -- Copy glyph to clipboard instead of inserting
		copy_register = "+", -- Register to use for copying (if `copy_to_clipboard` is true)
	},
}
