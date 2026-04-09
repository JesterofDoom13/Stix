return {
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				harper_ls = {
					filetypes = { "markdown" },
					settings = {
						["harper-ls"] = {
							userDictPath = vim.fn.stdpath("config") .. "/spell/harper_dict.txt",
						},
					},
				},
				nil_ls = { enabled = false },
				nixd = {
					enabled = true,
					settings = {
						nixd = {
							formatting = {
								command = { "nixpkgs-fmt" },
							},
						},
					},
				},
			},
		},
	},
}
