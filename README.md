# dotfiles

- Windows, Ubuntuを想定
- 現状WSL環境のみ

## prerequisite

Ubuntu側のみ

- mise
- chezmoi
  - mise で管理する
- zsh-syntax-highliting
- zsh-autosuggestions
  - 上記二つはaptで入れる

## setup - Ubuntu

```zsh
sudo apt update
sudo apt install mise zsh-syntax-highlighting zsh-autosuggestions
mise use -g chezmoi
chezmoi apply
curl -fsSL https://raw.githubusercontent.com/taka-kawah/dotfiles/main/install.sh | bash
source ~/.zshrc
```

## setup - Windows

wezterm とフォント等入れるだけ

`git clone` が必要😥

```powershell
git clone https://github.com/taka-kawah/dotfiles.git
Set-Location dotfiles
.\install.ps1
```
