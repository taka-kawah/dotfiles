local wezterm = require("wezterm")
local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.keys = require("keymap")

-- Ubuntu と PowerShell にはアイコンがつく
wezterm.on("format-tab-title", function (tab)
    local pane = tab.active_pane
    local process = (pane.foreground_process_name or ""):lower()
    local title = (pane.title or ""):lower()

    if process:find("wsl") or title:find("wslhost") then
        return "\u{F17C} Ubuntu"
    elseif process:find("pwsh") or title:find("pwsh") then
        return "\u{F17A} PowerShell"
    end
end)

-- appearence
config.window_background_opacity = 0.90
config.win32_system_backdrop = "Disable"
config.color_scheme = 'Kanagawa (Gogh)'
config.font = wezterm.font("FiraCode Nerd Font Mono", { weight = 'Bold'})
config.font_size = 10
config.enable_scroll_bar = true
-- config.default_cursor_style = 'BlinkingUnderline'
config.use_ime = true
config.window_padding = { left = 12, right = 12, top = 10, bottom = 10 }

-- ウインドウ右上に最大化、最小化、閉じるボタンを表示
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.window_frame = {
  font = wezterm.font("FiraCode Nerd Font Mono"),
  font_size = 9.0,
}
-- config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = true

config.window_padding = {
    left = 2,
    right = 2,
    top = 4,
    bottom = 1
}

-- カーソルを縦線にする
config.default_cursor_style = "SteadyBar"
-- アプリが点滅カーソルを要求しても点滅させない
config.cursor_blink_rate = 0

-- launcher menu
config.launch_menu = {
    {
        label = "Powershell 7",
        args = { "pwsh.exe", "-NoLogo" },
    },
    {
        label = "Ubuntu",
        args = { "wsl.exe", "-d", "Ubuntu", "--cd", "~" },
    },
    {
        label = "Powershell (Admin)",
        domain = { DomainName = "local" },
        args = {
            "pwsh.exe",
            "-NoProfile",
            "-Command",
            "Start-Process pwsh.exe -Verb RunAs"
        }
    }
}

-- system
config.default_prog = { "wsl.exe", "-d", "Ubuntu", "--cd", "~" }
config.scrollback_lines = 1000
config.audible_bell = "Disabled"
config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- 描画エンジンをかえる
config.front_end = 'OpenGL'

-- ウインドウの伸び縮みを防ぐ
config.adjust_window_size_when_changing_font_size = false

return config
