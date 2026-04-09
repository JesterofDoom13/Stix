return {
	"arakkkkk/kanban.nvim",
	dependencies = {
		"nvim-telescope/telescope.nvim",
	},
  -- stylua: ignore
	keys = {
		{ "<leader>kk", "<cmd>KanbanOpen ~/.config/home-manager/assets/obsidian/kanban/kanban.md<cr>", desc = "Kanban Primary",},
		{ "<leader>ld", "<cmd>KanbanListDelete<cr>", desc = "Kanban Delete Task" },
		{ "<leader>lr", "<cmd>KanbanListRename<cr>", desc = "Kanban Rename Task" },
		{ "<leader>la", "<cmd>KanbanListAdd<cr>", desc = "Kanban Add Task" },
	},

	opts = {
		markdown = {
			description_folder = "./tasks/", -- Path to save the file corresponding to the task.
			list_head = "## ",
		},
	},
}
