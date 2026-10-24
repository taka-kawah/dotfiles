$ErrorActionPreference = 'Stop'

scoop bucket add versions
scoop bucket add nerd-fonts
scoop install versions/wezterm-nightly nerd-fonts/FiraCode-NF-Mono

New-Item -ItemType Directory -Force "$HOME\.config\wezterm" | Out-Null
Copy-Item -Force "$PSScriptRoot\windows\wezterm\*" "$HOME\.config\wezterm"
