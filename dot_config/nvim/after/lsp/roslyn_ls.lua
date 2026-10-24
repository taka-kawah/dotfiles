-- .NET 10を探す
local dotnet10 = vim.fn.systemlist {
  "mise",
  "where",
  "dotnet@10",
}

assert(vim.v.shell_error == 0, ".NET 10が見つかりません")

--roslyn 起動設定
return {
  cmd = {
    vim.fn.expand "~/.dotnet/tools/roslyn-language-server",
    "--stdio",
    "--logLevel",
    "Warning",
    "--extensionLogDirectory",
    "/tmp/roslyn-logs",
  },

  cmd_env = {
    DOTNET_ROOT = dotnet10[1],
    DOTNET_MSBUILD_SDK_RESOLVER_SKDS_DIR = vim.fn.expand "~/.local/share/mise/installs/dotnet/8.0.411/sdk/8.0.411/Sdks/",
  },

  on_init = {
    function(client)
      local root = client.config.root_dir
      if not root then
        vim.notify("Roslyn: project root not found", vim.log.levels.ERROR)
        return
      end

      local solutions = {}

      for name, type in vim.fs.dir(root) do
        if type == "file" and (vim.endswith(name, ".sln") or vim.endswith(name, ".slnx")) then
          table.insert(solutions, vim.fs.joinpath(root, name))
        end
      end

      table.sort(solutions)

      if #solutions == 0 then
        vim.notify("Roslyn: no solution found", vim.log.levels.WARN)
        return
      end

      vim.schedule(function()
        vim.ui.select(solutions, {
          prompt = "Select .NET solution:",
          format_item = function(path) return vim.fn.fnamemodify(path, ":t") end,
        }, function(selected)
          if not selected then return end

          client:notify("solution/open", {
            solution = vim.uri_from_fname(selected),
          })

          vim.notify("Loading: " .. vim.fn.fnamemodify(selected, ":t"))
        end)
      end)
    end,
  },
}
