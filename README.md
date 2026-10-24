# dotfiles

Windows, Ubuntuを想定
現状WSL環境のみ

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
./install.sh
chezmoi apply
source ~/.zshrc
```

## setup - Windows

wezterm 入れるだけ

```
.\install.ps1
```
