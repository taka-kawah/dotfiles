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
./install.sh
source ~/.zshrc
```

## setup - Windows

wezterm 入れるだけ

```Powershell
.\install.ps1
```

こうなったら

```Powershell
Line |
   8 |  & "$PSScriptRoot\windows\fonts\Install-PlemolJP.ps1"
     |    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     | ファイル C:\Users\kawah\dotfiles\windows\fonts\Install-PlemolJP.ps1 を読み込めません。ファイル C:\Users\kawah\dotfiles\windows\fonts\Install-PlemolJP.ps1
     | はデジタル署名されていません。現在のシステムでこのスクリプトを実行することはできません。スクリプトの実行と実行ポリシーの設定の詳細については、https://go.microsoft.com/fwlink/?LinkID=135170 で about_Execution_Policies を参照してください。
```
これを実行する。
```Powershell
Unblock-File .\windows\fonts\Install-PlemolJP.ps1
```
