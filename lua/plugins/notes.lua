return {
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "folke/snacks.nvim",
      "nvim-treesitter/nvim-treesitter",
      "hrsh7th/nvim-cmp",
    },
    keys = {
      { "<leader>on", "<cmd>Obsidian new<cr>", desc = "New Obsidian Note" },
      { "<leader>oo", "<cmd>Obsidian open<cr>", desc = "Open in Obsidian App" },
      { "<leader>os", "<cmd>Obsidian search<cr>", desc = "Search Obsidian Notes" },
      { "<leader>op", "<cmd>Obsidian<cr>", desc = "Obsidian Picker" },
      { "<leader>oq", "<cmd>Obsidian quick_switch<cr>", desc = "Quick Switch Note" },
      { "<leader>od", "<cmd>Obsidian today<cr>", desc = "Obsidian Today" },
      { "<leader>ot", "<cmd>Obsidian template<cr>", desc = "Obsidian Template" },
      { "<leader>ob", "<cmd>Obsidian backlinks<cr>", desc = "Obsidian Backlinks" },
      { "<leader>ch", "<cmd>Obsidian checkbox<cr>", desc = "Obsidian Checkbox" },
      { "gf", function() if require("obsidian").util.cursor_on_markdown_link() then return "<cmd>Obsidian follow_link<cr>" else return "gf" end end, desc = "Obsidian Follow Link", expr = true, ft = "markdown" },
    },
    opts = {
      legacy_commands = false,
      workspaces = {
        {
          name = "personal",
          path = "~/zettel",
        },
      },
      daily_notes = {
        folder = "daily",
        date_format = "%Y-%m-%d",
        template = nil,
      },
      picker = {
        name = "snacks.picker",
      },
      -- Optional, customize how note IDs are generated given an optional title.
      ---@param title string|?
      ---@return string
      note_id_func = function(title)
        -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
        -- In this case a note with the title 'My new note' will be given an ID that looks
        -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
        local suffix = ""
        if title ~= nil then
          -- If title is given, transform it into valid file name.
          suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        else
          -- If title is nil, just add 4 random uppercase letters to the suffix.
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
        end
        return tostring(os.time()) .. "-" .. suffix
      end,

      -- Optional, customize how note file names are generated given the ID, target directory, and title.
      ---@param spec { id: string, dir: obsidian.Path, title: string|? }
      ---@return string|obsidian.Path The full path to the new note.
      note_path_func = function(spec)
        -- This is equivalent to the default behavior.
        local path = spec.dir / tostring(spec.id)
        return path:with_suffix(".md")
      end,
    },
  },
}
