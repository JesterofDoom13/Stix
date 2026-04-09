local crates = require("crates")
return {
	{
		"saecki/crates.nvim",
		event = "VeryLazy",
		lazy = true,
		ft = { "rust" },
    -- stylua: ignore
		keys = {
			{"<leader>Ct", crates.toggle,  desc = "Toggle Crates"},
			{"<leader>Cr", crates.reload,  desc = "Reload Crates"},

			{"<leader>Cv", crates.show_versions_popup,  desc = "Show Version Popup"},
			{"<leader>Cf", crates.show_features_popup,  desc = "Show Features Popup"},
			{"<leader>Cd", crates.show_dependencies_popup, desc = "Show Depend Popup" },

			{"<leader>Ca", crates.update_all_crates,  desc = "Update all Crates"},
			{"<leader>CA", crates.upgrade_all_crates,  desc = "Upgrade all Crates"},

			{"<leader>Cx", crates.expand_plain_crate_to_inline_table,  desc = "Expand Plain"},
			{"<leader>CX", crates.extract_crate_into_table,  desc = "Extract Crates to table"},

			{"<leader>CH", crates.open_homepage,  desc = "Open Homepage"},
			{"<leader>CR", crates.open_repository,  desc = "Open Repo"},
			{"<leader>CD", crates.open_documentation,  desc = "Open Docs"},
			{"<leader>CC", crates.open_crates_io,  desc = "Open Crates.io"},
			{"<leader>CL", crates.open_lib_rs,  desc = "Open Lib.rs"},

			{"<leader>Cu", crates.update_crate, mode = {"n", "v"},  desc = "Update Crate"},
			{"<leader>CU", crates.upgrade_crates, mode = {"n", "v"}, desc = "Upgrade Crates"},
		},
		opts = {},
	},
}
