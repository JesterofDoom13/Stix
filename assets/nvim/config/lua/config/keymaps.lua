local del = vim.keymap.del
local map = vim.keymap.set

-- stylua: ignore
del("n", "<leader>|")
del("n", "<leader>-")
-- del("n", "<leader>in")
-- del("n", "<leader>iN")
map("n", "<leader>;", function()
	vim.cmd("vsplit")
end, { desc = "Vertical Split" })
map("n", "<leader>'", function()
	vim.cmd("split")
end, { desc = "Horizontal Split" })

-- WHICH-KEY ADDITIONS __
local add = require("which-key").add
add({ "<leader>C", group = "Crates", icon = " " })
add({ "<leader>k", group = "Kanban", icon = " " })
add({ "<leader>K", icon = " " })
add({ "<leader>mf", group = "Footnotes", icon = " " })
add({ "<leader>mQ", group = "Callbacks", icon = " " })
add({ "<leader>m", group = "Markdown", icon = " " })
add({ "<leader>h", group = "Headers", icon = " " })
add({ "<leader>r", group = "Mini.Operators", icon = " " })
add({ "<leader>;", group = "Vertical Split", icon = " " })
add({ "<leader>'", group = "Horizontal Split", icon = " " })
add({ "<leader>o", group = "Obsidian", icon = "󰇈 " })
