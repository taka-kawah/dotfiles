local wezterm = require("wezterm")

return {
  {
    key = "phys:1",
    mods = "CTRL|SHIFT",
    action = wezterm.action.SpawnCommandInNewTab {
      args = { "wsl.exe", "-d", "Ubuntu", "--cd", "~" },
    },
  },
  {
    key = "phys:2",
    mods = "CTRL|SHIFT",
    action = wezterm.action.SpawnCommandInNewTab {
      args = { "pwsh.exe", "-NoLogo" },
    },
  },
  {
    key = "phys:3",
    mods = "CTRL|SHIFT",
    action = wezterm.action.SpawnCommandInNewTab {
      args = {
        "pwsh.exe",
        "-NoProfile",
        "-Command",
        "Start-Process pwsh.exe -ArgumentList '-NoLogo' -Verb RunAs",
      },
    },
  },
  {
    key = "w",
    mods = "CTRL|SUPER",
    action = wezterm.action.QuitApplication,
  },
}
