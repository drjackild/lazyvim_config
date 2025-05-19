-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Vimwiki bind to toggle TODO list items
vim.keymap.set("n", "<A-x>", "<cmd>VimwikiToggleListItem<CR>", { desc = "(Vimwiki) Toggle list item" })
