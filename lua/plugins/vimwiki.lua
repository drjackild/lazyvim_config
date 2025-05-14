return {
  {
    -- The plugin location on GitHub
    "vimwiki/vimwiki",
    -- The keys that trigger the plugin
    keys = { "<leader>ww", "<leader>wt" },
    -- The configuration for the plugin
    init = function()
      vim.g.vimwiki_list = {
        {
          -- Here will be the path for your wiki
          path = "~/zettel/",
          -- The syntax for the wiki
          syntax = "markdown",
          ext = "md",
          diary_rel_path = "daily/",
        },
      }
      vim.g.vimwiki_ext2syntax = { [".md"] = "markdown", [".markdown"] = "markdown", [".mdown"] = "markdown" }
      vim.g.vimwiki_use_mouse = 1
      vim.g.vimwiki_markdown_link_ext = 1
      vim.g.vimwiki_auto_header = 1
    end,
  },
}
