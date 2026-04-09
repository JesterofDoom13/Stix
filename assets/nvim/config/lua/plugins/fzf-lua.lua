return {
	"ibhagwan/fzf-lua",
	-- optional for icon support
	event = "VeryLazy",
	-- priority = 1000,
	lazy = true,
	dependencies = { "nvim-tree/nvim-web-devicons" },
  -- or if using mini.icons/mini.nvim
  -- dependencies = { "nvim-mini/mini.icons" },
  -- stylua: ignore
  -- Stole this look from Coding with Sphere video "11 Small but Useful Neovim Plugins"
  keys = {
    { "<leader><leader>", function() require("fzf-lua").buffers() end, desc = "View current buffers",},
    { "<leader>/",        function() require("fzf-lua").lgrep_curbuf() end, desc = "[/] grep current buffers", },
    { "<leader>fb",       function() require("fzf-lua").builtin() end,      desc = "[F]ind [B]uiltins", },
    { "<leader>fr",       function() require("fzf-lua").resume() end,       desc = "[F]ind [R]esume", },
    { "<leader>fh",       function() require("fzf-lua").helptags() end,     desc = "[F]ind [H]elptags", },
    { "<leader>fw",       function() require("fzf-lua").grep_cword() end,   desc = "[F]ind current [w]ord", },
    { "<leader>fW",       function() require("fzf-lua").grep_cWORD() end,   desc = "[F]ind current [W]ord", },
    { "<leader>fo",       function() require("fzf-lua").oldfiles() end,     desc = "[F]ind [o]ldfiles", },
  },
	---@module "fzf-lua"
	---@type fzf-lua.Config|{}
	---@diagnostics disable: missing-fields
	opts = {},
	---@diagnostics enable: missing-fields
}
