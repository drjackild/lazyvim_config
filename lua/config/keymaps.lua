-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local opts = function(desc)
  return { noremap = true, silent = false, desc = desc }
end

local ok, wk = pcall(require, "which-key")
if ok then
  wk.add({
    { "<leader>o", group = "Org" },
  })
end
