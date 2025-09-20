-- Add the key mappings only for Markdown files in a zk notebook.
if require("zk.util").notebook_root(vim.fn.expand("%:p")) ~= nil then
  local function map(...)
    vim.api.nvim_buf_set_keymap(0, ...)
  end
  local opts = function(desc)
    return { noremap = true, silent = false, desc = desc }
  end

  -- Open the link under the caret.
  map("n", "<CR>", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts("Open link"))

  -- Create a new note after asking for its title.
  -- This overrides the global `<leader>zn` mapping to create the note in the same directory as the current buffer.
  map(
    "n",
    "<leader>zn",
    "<Cmd>ZkNew { dir = vim.fn.expand('%:p:h'), title = vim.fn.input('Title: ') }<CR>",
    opts("New note")
  )
  -- Create a new note in the same directory as the current buffer, using the current selection for title.
  map(
    "v",
    "<leader>znt",
    ":'<,'>ZkNewFromTitleSelection { dir = vim.fn.expand('%:p:h') }<CR>",
    opts("New note (title under selection)")
  )
  -- Create a new note in the same directory as the current buffer, using the current selection for note content and asking for its title.
  map(
    "v",
    "<leader>znc",
    ":'<,'>ZkNewFromContentSelection { dir = vim.fn.expand('%:p:h'), title = vim.fn.input('Title: ') }<CR>",
    opts("New note (content under selection)")
  )

  -- This overrides the global `<leader>zn` mapping to create the note in the same directory as the current buffer.
  map(
    "n",
    "<leader>zd",
    "<Cmd>lua require('zk').new({ template = 'daily.md', group = 'daily', dir = 'daily' })<CR>",
    opts("New daily note")
  )
  -- map("n", "<leader>zd", "<Cmd>ZkNew { template = 'daily.md', group = 'daily' }<CR>", opts)

  -- Open notes linking to the current buffer.
  map("n", "<leader>zb", "<Cmd>ZkBacklinks<CR>", opts("Get note backlinks"))
  -- Alternative for backlinks using pure LSP and showing the source context.
  --map('n', '<leader>zb', '<Cmd>lua vim.lsp.buf.references()<CR>', opts)
  -- Open notes linked by the current buffer.
  map("n", "<leader>zl", "<Cmd>ZkLinks<CR>", opts("Get note backlinkgs (LSP)"))

  -- Preview a linked note.
  map("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts("Get note preview"))
  -- Open the code actions for a visual selection.
  map("v", "<leader>za", ":'<,'>lua vim.lsp.buf.range_code_action()<CR>", opts("Open code actions"))
end
