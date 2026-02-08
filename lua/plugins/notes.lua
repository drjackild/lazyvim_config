local notes = require("config.notes")
local backend = notes.get_backend()
local path = notes.get_path()
local daily_folder = notes.get_daily_folder()

return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },
  {
    "obsidian-nvim/obsidian.nvim",
    enabled = backend == "obsidian",
    version = "*",
    lazy = true,
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "folke/snacks.nvim",
      "nvim-treesitter/nvim-treesitter",
      "hrsh7th/nvim-cmp",
    },
    keys = {
      {
        "<leader>on",
        function()
          local client = require("obsidian").get_client()
          vim.ui.input({ prompt = "Note Title: " }, function(title)
            if not title or title == "" then
              return
            end
            -- List subdirectories for selection
            local scan = require("plenary.scandir")
            local dirs = scan.scan_dir(tostring(client.dir), { only_dirs = true, depth = 3 })
            -- Add root
            table.insert(dirs, 1, tostring(client.dir))

            vim.ui.select(dirs, {
              prompt = "Select Folder:",
              format_item = function(item)
                return vim.fn.fnamemodify(item, ":~:.")
              end,
            }, function(selected_dir)
              if not selected_dir then
                return
              end
              -- Calculate relative path for Obsidian command if needed, or just pass absolute
              client:command("New", { args = { title }, bang = true })
              -- Note: ObsidianNew command is tricky with specific dirs without changing workspace settings on the fly.
              -- A better approach might be to manually construct the path and open it, or rely on note_path_func logic if we can pass context.
              -- However, obsidian.nvim doesn't easily let us override dir per-call in `note_path_func`.
              -- Let's try to move the file after creation or use `create_note` API directly.

              -- Actually, simpler approach using the API:
              local note = client:create_note({ title = title, dir = selected_dir })
              client:open_note(note)
            end)
          end)
        end,
        desc = "New Note",
      },
      { "<leader>os", "<cmd>Obsidian search<cr>", desc = "Search Notes" },
      { "<leader>ot", "<cmd>Obsidian today<cr>", desc = "Today's Note" },
      { "<leader>ob", "<cmd>Obsidian backlinks<cr>", desc = "Backlinks" },
      { "<leader>oo", "<cmd>Obsidian open<cr>", desc = "Open in App" },
      { "<leader>op", "<cmd>Obsidian<cr>", desc = "Picker" },
      {
        "gf",
        function()
          if require("obsidian").util.cursor_on_markdown_link() then
            return "<cmd>Obsidian follow_link<cr>"
          else
            return "gf"
          end
        end,
        desc = "Obsidian Follow Link",
        expr = true,
        ft = "markdown",
      },
    },
    opts = {
      legacy_commands = false,
      workspaces = {
        {
          name = "default",
          path = path,
        },
      },
      daily_notes = {
        folder = daily_folder,
        date_format = "%Y-%m-%d",
        template = nil,
      },
      picker = {
        name = "snacks.picker",
      },
      note_id_func = function(title)
        local suffix = ""
        if title ~= nil then
          suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        else
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
        end
        return suffix
      end,
      note_path_func = function(spec)
        local path = spec.dir / tostring(spec.id)
        return path:with_suffix(".md")
      end,
    },
  },
  {
    "zk-org/zk-nvim",
    enabled = backend == "zk",
    lazy = true,
    ft = "markdown",
    keys = {
      {
        "<leader>on",
        function()
          vim.ui.input({ prompt = "Title: " }, function(title)
            if not title or title == "" then
              return
            end
            -- Using a simple find command to get dirs is usually sufficient, or let Zk prompt if we can.
            -- Zk doesn't expose a 'list dirs' API easily to lua, so we can use fd/find.
            local dirs =
              vim.fn.systemlist("find " .. vim.fn.shellescape(vim.env.ZK_NOTEBOOK_DIR) .. " -type d -not -path '*/.*'")

            vim.ui.select(dirs, {
              prompt = "Select Folder:",
              format_item = function(item)
                return vim.fn.fnamemodify(item, ":~:.")
              end,
            }, function(selected_dir)
              if selected_dir then
                require("zk").new({ title = title, dir = selected_dir })
              end
            end)
          end)
        end,
        desc = "New Note",
      },
      { "<leader>os", "<cmd>ZkNotes<cr>", desc = "Search Notes" },
      {
        "<leader>ot",
        "<cmd>ZkNew { date = 'today', dir = '" .. daily_folder .. "', group = '" .. daily_folder .. "' }<cr>",
        desc = "Today's Note",
      },
      { "<leader>ob", "<cmd>ZkBacklinks<cr>", desc = "Backlinks" },
    },
    config = function()
      if path and path ~= "" then
        vim.env.ZK_NOTEBOOK_DIR = vim.fn.expand(path)
      else
        -- Fallback if path isn't set, though get_path has a default
        vim.env.ZK_NOTEBOOK_DIR = vim.fn.expand("~/zettel")
      end
      require("zk").setup({
        picker = "select",
      })
    end,
  },
}
