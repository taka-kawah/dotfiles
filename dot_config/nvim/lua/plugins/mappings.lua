return {
  "AstroNvim/astrocore",
  opts = {
    mappings = {
      n = {
        gD = {
          function()
            vim.cmd "rightbelow vsplit"
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("gd", true, false, true), "m", false)
          end,
          desc = "Go to definition in right split",
        },
      },
    },
  },
}
