return {
  -- neodev
  {
    "folke/neodev.nvim",
    opts = {
      library = {
        enabled = true,
        plugins = true,
      },
    },
  },
  -- neoconf
  {
    "folke/neoconf.nvim",
    cmd = "Neoconf",
    opts = {
      plugins = {
        lua_ls = {
          enabled = true,
        },
      },
    },
  },
}
