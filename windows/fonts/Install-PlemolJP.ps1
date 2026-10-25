<#
.SYNOPSIS
    PlemolJP Console NF をユーザー単位でインストールする（管理者権限不要）
.DESCRIPTION
    1. すでに入っていれば何もしない
    2. GitHub Releases から zip をダウンロードして展開
    3. ユーザーのフォントフォルダに置き、レジストリに登録して今のセッションにも反映
#>
param(
    [string]$Version = 'v3.1.0'
)

$ErrorActionPreference = 'Stop'
# Invoke-WebRequest の進捗表示で極端に遅くなるのを防ぐ
$ProgressPreference = 'SilentlyContinue'

$FilePrefix    = 'PlemolJPConsoleNF'          # ttf ファイル名の頭
$SubDir        = 'PlemolJPConsole_NF'         # zip 内のフォルダ（幅 1:2 の Console 版）
$UserFontDir   = Join-Path $env:LOCALAPPDATA 'Microsoft\Windows\Fonts'
$SystemFontDir = Join-Path $env:WINDIR 'Fonts'
$RegKey        = 'HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Fonts'

# --- 1. インストール済みなら何もしない ------------------------------------
$installed = @($UserFontDir, $SystemFontDir) |
    Where-Object { Test-Path (Join-Path $_ "$FilePrefix-Regular.ttf") }
if ($installed) {
    Write-Host "PlemolJP Console NF is already installed. Skipping."
    return
}

# --- 2. ダウンロードして展開 ----------------------------------------------
$zipName = "PlemolJP_NF_$Version"
$url     = "https://github.com/yuru7/PlemolJP/releases/download/$Version/$zipName.zip"
$work    = Join-Path ([IO.Path]::GetTempPath()) ([guid]::NewGuid().ToString())
New-Item -ItemType Directory -Path $work | Out-Null

try {
    $zip = Join-Path $work "$zipName.zip"
    Write-Host "Downloading $url"
    Invoke-WebRequest -Uri $url -OutFile $zip
    Expand-Archive -Path $zip -DestinationPath $work

    # --- 3. フォントフォルダに置いてレジストリに登録 ----------------------
    New-Item -ItemType Directory -Force -Path $UserFontDir | Out-Null
    if (-not (Test-Path $RegKey)) {
        New-Item -Path $RegKey -Force | Out-Null
    }

    # 再起動しなくても今のセッションで使えるようにする Win32 API
    if (-not ('Win32.FontApi' -as [type])) {
        Add-Type -Namespace Win32 -Name FontApi -MemberDefinition @'
[DllImport("gdi32.dll", CharSet = CharSet.Unicode)]
public static extern int AddFontResource(string lpFileName);

[DllImport("user32.dll", CharSet = CharSet.Unicode)]
public static extern IntPtr SendMessageTimeout(
    IntPtr hWnd, uint Msg, UIntPtr wParam, IntPtr lParam,
    uint fuFlags, uint uTimeout, out UIntPtr lpdwResult);
'@
    }

    $fonts = Get-ChildItem -Path (Join-Path $work "$zipName\$SubDir") -Filter '*.ttf'
    foreach ($font in $fonts) {
        $dest = Join-Path $UserFontDir $font.Name
        Copy-Item -Path $font.FullName -Destination $dest -Force
        New-ItemProperty -Path $RegKey -Name "$($font.BaseName) (TrueType)" `
            -Value $dest -PropertyType String -Force | Out-Null
        [Win32.FontApi]::AddFontResource($dest) | Out-Null
    }

    # 開いているアプリに「フォントが増えたよ」と知らせる（WM_FONTCHANGE）
    $result = [UIntPtr]::Zero
    [Win32.FontApi]::SendMessageTimeout(
        [IntPtr]0xffff, 0x001D, [UIntPtr]::Zero, [IntPtr]::Zero,
        2, 1000, [ref]$result) | Out-Null

    Write-Host "Installed $($fonts.Count) fonts: PlemolJP Console NF"
}
finally {
    Remove-Item -Path $work -Recurse -Force -ErrorAction SilentlyContinue
}
