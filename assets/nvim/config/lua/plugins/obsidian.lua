return {
	"obsidian-nvim/obsidian.nvim",
	version = "*", -- recommended, use latest release instead of latest commit
	ft = "markdown",
	---@module 'obsidian'
	---@diagnostic disable-next-line: undefined-doc-name
	---@type obsidian.config
	---@diagnostic disable-next-line: assign-type-mismatch
	cmd = "Obsidian",

	keys = {
		{ "<leader>on", "<cmd>Obsidian new<cr>", desc = "New Obsidian note" },
		{ "<leader>oS", "<cmd>Obsidian search<cr>", desc = "Search Obsidian notes" },
		{ "<leader>os", "<cmd>Obsidian quick_switch<cr>", desc = "Quick Switch" },
		{ "<leader>ob", "<cmd>Obsidian backlinks<cr>", desc = "Show location list of backlinks" },
		{ "<leader>ot", "<cmd>Obsidian template<cr>", desc = "Open templates" },
		{ "<leader>op", "<cmd>Obsidian paste_img<cr>", desc = "Paste image from clipboard under cursor" },
	},
	opts = {
		legacy_commands = false, -- this will be removed in the next major release
		ui = {
			enable = false,
		},
		workspaces = {
			{
				name = "Personal",
				path = "~/Documents/.workspaces",
			},
		},
		templates = {
			folder = "templates",
			date_format = "%Y-%m-%d",
			time_format = "%H:%M",
			substitutions = {
				yesterday = function()
					return os.date("%Y-%m-%d", os.time() - 86400)
				end,
				substitutions = {
					tomorrow = function()
						return os.date("%Y-%m-%d", os.time() + 86400)
					end,
				},
			},
		},
		daily_notes = {
			folder = "Journal",
			date_format = "%Y-%m-%d",
			alias_format = "%B %-d, %Y",
			default_tags = { "daily-notes" },
			template = "daily.md",
			workdays_only = false,
		},
		checkbox = {
			enabled = true,
			create_new = true,
			order = { " ", "x", "~", "!", ">" },
		},
		attachments = {
			folder = "./assets",
			img_text_func = function(path)
				local name = vim.fs.basename(tostring(path))
				local encoded_name = require("obsidian.util").urlencode(name)
				return string.format("![%s](./assets/%s)", name, encoded_name)
			end,
		},
		---@param id string
		---@param dir obsidian.Path
		---@return string
		note_id_func = function(id, dir)
			local daily_notes_dir = Obsidian.dir / Obsidian.opts.daily_notes.folder
			if daily_notes_dir == dir then
				return id
			end
			return require("obsidian.builtin").zettel_id() -- or whatever customizations you did
		end,
	},
}
