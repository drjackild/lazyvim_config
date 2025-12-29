-- Check if we are inside a ZK notebook
if require("zk.util").notebook_root(vim.fn.expand("%:p")) ~= nil then
  local function map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = true, silent = true, desc = "ZK: " .. desc })
  end

  -----------------------------------------------------------------------------
  -- NEW NOTE CREATION (Custom Logic)
  -----------------------------------------------------------------------------

  -- The function we built: Custom slug, current dir, and inserts link at cursor
  local function new_note_in_place()
    local title = vim.fn.input("Note Title: ")
    if title == "" then
      return
    end

    local slug = title:lower():gsub("[%s%-]+", "_"):gsub("[^%w_]+", "")
    local client = vim.lsp.get_active_clients({ name = "zk" })[1]
    local encoding = client and client.offset_encoding or "utf-16"
    local location = vim.lsp.util.make_position_params(0, encoding).position

    require("zk").new({
      title = title,
      extra = { slug = slug },
      dir = vim.fn.expand("%:p:h"),
      insertLinkAtLocation = {
        uri = vim.uri_from_bufnr(0),
        range = { start = location, ["end"] = location },
      },
    })
  end

  map("n", "<leader>zn", new_note_in_place, "New Note (Insert Link Here)")

  -----------------------------------------------------------------------------
  -- NAVIGATION & DISCOVERY
  -----------------------------------------------------------------------------

  -- Open note under cursor
  map("n", "<CR>", "<Cmd>lua vim.lsp.buf.definition()<CR>", "Open link")

  -- Preview note under cursor
  map("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", "Preview note")

  -- Search notes (Essential for Zettelkasten)
  map("n", "<leader>zs", "<Cmd>ZkNotes { sort = { 'modified' } }<CR>", "Search notes")

  -- Search tags
  map("n", "<leader>zt", "<Cmd>ZkTags<CR>", "Search tags")

  -----------------------------------------------------------------------------
  -- LINKING & BACKLINKS
  -----------------------------------------------------------------------------

  -- Insert a link to an existing note at the current cursor position
  map("n", "<leader>zi", "<Cmd>ZkInsertLink<CR>", "Insert link to note")

  -- Show notes that link to this note
  map("n", "<leader>zb", "<Cmd>ZkBacklinks<CR>", "Backlinks")

  -- Show notes that this note links to
  map("n", "<leader>zl", "<Cmd>ZkLinks<CR>", "Outbound links")

  -----------------------------------------------------------------------------
  -- SPECIAL OPERATIONS
  -----------------------------------------------------------------------------

  -- Create daily note
  map("n", "<leader>zd", function()
    require("zk").new({ template = "daily.md", group = "daily", dir = "daily" })
  end, "New daily note")

  -- Create note from visual selection (Title)
  map(
    "v",
    "<leader>znt",
    ":'<,'>ZkNewFromTitleSelection { dir = vim.fn.expand('%:p:h') }<CR>",
    "New note (Title selection)"
  )

  -- Create note from visual selection (Content)
  map("v", "<leader>znc", function()
    local title = vim.fn.input("Title: ")
    if title ~= "" then
      vim.cmd(":'<,'>ZkNewFromContentSelection { dir = '" .. vim.fn.expand("%:p:h") .. "', title = '" .. title .. "' }")
    end
  end, "New note (Content selection)")

  -- Code actions (Renaming notes, etc.)
  map("v", "<leader>za", "<Cmd>lua vim.lsp.buf.range_code_action()<CR>", "Code actions")
end
