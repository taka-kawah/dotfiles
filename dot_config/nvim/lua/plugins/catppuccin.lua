return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      flavour = "frappe",
      integrations = {
        gitsigns = true,
        treesitter = true,
        diffview = true,
      },
    },
  },
  {
    "AstroNvim/astroui",
    opts = {
      colorscheme = "catppuccin-frappe",
    },
  },
}
