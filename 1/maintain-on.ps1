# 站点维护开启脚本：把网站入口临时替换为维护页
$ErrorActionPreference = 'Stop'
$dir = $PSScriptRoot
$maintenance = Join-Path $dir 'maintenance.html'
$candidates = @('index.html', 'index.html（主页面·模板库+iframe嵌入）.html')
$entry = $null
foreach ($c in $candidates) {
    $p = Join-Path $dir $c
    if (Test-Path $p) { $entry = $p; break }
}
if (-not $entry) {
    Write-Host '未找到网站入口文件（index.html），请检查后重试。' -ForegroundColor Red
    exit 1
}
$bak = $entry + '.bak'
if (Test-Path $bak) {
    Write-Host '检测到已存在备份，网站可能已在维护中，无需重复开启。' -ForegroundColor Yellow
} else {
    Rename-Item -LiteralPath $entry -NewName ([IO.Path]::GetFileName($bak))
    Copy-Item -LiteralPath $maintenance -Destination $entry
    Write-Host '维护已开启：用户访问的将是维护页，原首页已备份。' -ForegroundColor Green
}
Write-Host '入口文件: ' -NoNewline
Write-Host ([IO.Path]::GetFileName($entry)) -ForegroundColor Cyan

