return {
	{
		"rcarriga/nvim-dap-ui",
		event = "VeryLazy",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
	},
	{
		"igorlfs/nvim-dap-view",
		event = "VeryLazy",
		---@module 'dap-view'
		---@type dapview.Config
		opts = {},
	},
	{
		"julianolf/nvim-dap-lldb",
		event = "VeryLazy",
		dependencies = { "mfussenegger/nvim-dap" },
		opts = { codelldb_path = nixCats.cats.lldb.path },
	},
}
