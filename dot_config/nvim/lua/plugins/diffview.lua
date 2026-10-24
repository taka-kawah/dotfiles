local function select_commit()
  local result = vim
    .system({
      "git",
      "log",
      "-100",
      "--pretty=format:%h%x09%s",
    }, { text = true })
    :wait()

  if result.code ~= 0 then
    vim.notify(result.stderr, vim.log.levels.ERROR)
    return
  end

  local items = {}

  for line in result.stdout:gmatch "[^\r\n]+" do
    local sha, message = line:match "^(%S+)\t(.+)$"
    if sha then table.insert(items, {
      text = sha .. " " .. message,
      sha = sha,
    }) end
  end

  require("snacks").picker.pick {
    title = "Git Commits",
    items = items,
    format = "text",
    confirm = function(picker, item)
      picker:close()

      if item then vim.cmd("DiffviewOpen " .. item.sha .. "^!") end
    end,
  }
end

return {
  "sindrets/diffview.nvim",

  cmd = {
    "DiffviewOpen",
    "DiffviewFileHistory",
    "DiffviewClose",
  },

  opts = {
    enhanced_diff_hl = true,
    hooks = {
      view_opened = function()
        vim.opt.fillchars:append { diff = " " }

        require("diffview.config").actions.open_commit_log()
      end,
    },
    view = {
      default = {
        layout = "diff2_vertical",
      },
      file_history = {
        layout = "diff2_vertical",
      },
    },
    file_panel = {
      win_config = {
        position = "left",
        width = 35,
      },
    },
    commit_log_panel = {
      win_config = {
        type = "split",
        position = "bottom",
        height = 15,
        relative = "win",
        win = 0,
      },
    },
    keymaps = {
      view = {
        { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
      },
      file_panel = {
        { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
      },
      file_history_panel = {
        { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
      },
    },
  },

  keys = {
    {
      "<leader>gd",
      "<cmd>DiffviewOpen --imply-local<cr>",
      desc = "Git diff (working tree)",
    },
    {
      "<leader>ga",
      select_commit,
      desc = "Git diff (select commit)",
    },
  },
}
