return {
  { "ellisonleao/gruvbox.nvim" },
  { "navarasu/onedark.nvim" },
  {
    "catppuccin/nvim",
    name = "catppuccin",
		opts = function(_, opts)
			local module = require("catppuccin.groups.integrations.bufferline")
			if module then
				module.get = module.get_theme
			end
      opts.no_italic = true
			return opts
		end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-frappe",
    },
  },
}
