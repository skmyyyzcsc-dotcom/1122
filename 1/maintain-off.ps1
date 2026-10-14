# 站点维护恢复脚本：把网站入口还原为原首页
$ErrorActionPreference = 'Stop'
$dir = $PSScriptRoot
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
if (-not (Test-Path $bak)) {
    Write-Host '没有找到备份文件，网站不在维护状态，无需恢复。' -ForegroundColor Yellow
    exit 0
}
Remove-Item -LiteralPath $entry
Rename-Item -LiteralPath $bak -NewName ([IO.Path]::GetFileName($entry))
Write-Host '维护已结束：网站入口已恢复为原首页。' -ForegroundColor Green

