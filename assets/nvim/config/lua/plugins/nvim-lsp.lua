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
							options = {
								nixos = {
									expr = "(builtins.getFlake (builtins.toString ./.)).nixosCinfigurations.steamdeck.options",
								},
								home_manager = {
									expr = "(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.steamdeck.options.home-manager.users.type.getSubOptions []",
								},
							},
							diagnostic = {
								supress = {
									"sema-extra-with",
								},
							},
						},
					},
				},
			},
		},
	},
}
