# SoundIsle - command-line build script (no DevEco Studio GUI required)
# Usage: run from the project root:  ./build.ps1
$ErrorActionPreference = 'Continue'

$devEco = 'C:\Program Files\Huawei\DevEco Studio'
$project = Split-Path -Parent $MyInvocation.MyCommand.Path

$env:DEVECO_SDK_HOME = Join-Path $devEco 'sdk'
$env:JAVA_HOME = Join-Path $devEco 'jbr'
$env:PATH = (Join-Path $devEco 'jbr\bin') + ';' + (Join-Path $devEco 'tools\node') + ';' + $env:PATH

Set-Location $project

& (Join-Path $devEco 'tools\node\node.exe') (Join-Path $devEco 'tools\hvigor\bin\hvigorw.js') 'assembleHap' '--mode' 'module' '-p' 'product=default' '-p' 'buildMode=debug' '--no-daemon'
$exitCode = $LASTEXITCODE

if ($exitCode -ne 0) {
  Write-Host ''
  Write-Host "Build FAILED with exit code $exitCode" -ForegroundColor Red
  exit $exitCode
}

Write-Host ''
Write-Host 'Build succeeded. Output:'
Write-Host '  entry\build\default\outputs\default\entry-default-unsigned.hap'
Write-Host ''
