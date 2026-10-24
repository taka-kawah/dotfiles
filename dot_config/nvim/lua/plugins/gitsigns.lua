local function open_line_pr()
  local file = vim.api.nvim_buf_get_name(0)
  local line = vim.api.nvim_win_get_cursor(0)[1]
  local dir = vim.fn.fnamemodify(file, ":h")

  -- カーソル行のコミットSHA
  local blame = vim
    .system({
      "git",
      "blame",
      "--porcelain",
      "-L",
      line .. "," .. line,
      "--",
      vim.fn.fnamemodify(file, ":t"),
    }, { cwd = dir, text = true })
    :wait()

  if blame.code ~= 0 then
    vim.notify("git blame failed" .. (blame.stderr or ""), vim.log.levels.ERROR)
    return
  end

  local sha = blame.stdout:match "^(%x+)"
  if not sha or sha:match "^0+$" then
    vim.notify "コミットされていない行だぜ"
    return
  end

  -- 最も早くマージされたPRのURL
  local result = vim
    .system({
      "gh",
      "api",
      "repos/Amiya-Corp/ALog/commits/" .. sha .. "/pulls",
      "--jq",
      "[.[] | select(.merged_at != null)] | sort_by(.merged_at) | .[0].html_url // empty",
    }, { cwd = dir, text = true })
    :wait()

  local url = vim.trim(result.stdout or "")
  if result.code ~= 0 or url == "" then
    vim.notify("関連するマージ済みPRが見つからない", vim.log.levels.WARN)
    return
  end

  -- Windowsのブラウザで開く
  vim.fn.jobstart({ "explorer.exe", url }, { detach = true })
end

vim.keymap.set("n", "<leader>gq", open_line_pr, {
  desc = "Open line PR on GitHub",
})

return {
  "lewis6991/gitsigns.nvim",
  opts = {
    current_line_blame = true,
    current_line_blame_opts = {
      delay = 1000,
      virt_text_pos = "eol",
    },
    current_line_blame_formatter = "          <author>, <author_time:%Y-%m-%d> - <summary>",
  },
}
