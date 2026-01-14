$files = @('logo2','vava','cs2','blod','far')
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$imgDir = Join-Path $scriptDir '..\images\opt' | Resolve-Path

function Try-Run([string]$cmd, [string]$args) {
    try {
        $proc = Start-Process -FilePath $cmd -ArgumentList $args -NoNewWindow -Wait -PassThru -ErrorAction Stop
        return $true
    } catch {
        return $false
    }
}

# Check available converters
$hasMagick = (Get-Command magick -ErrorAction SilentlyContinue) -ne $null
$hasCwebp = (Get-Command cwebp -ErrorAction SilentlyContinue) -ne $null
$hasPython = (Get-Command python -ErrorAction SilentlyContinue) -ne $null -or (Get-Command python3 -ErrorAction SilentlyContinue) -ne $null

Write-Host "magick:" $hasMagick "cwebp:" $hasCwebp "python:" $hasPython

foreach ($name in $files) {
    $png = Join-Path $imgDir ($name + '.png')
    $png2 = Join-Path $imgDir ($name + '@2x.png')
    $webp = Join-Path $imgDir ($name + '.webp')
    $webp2 = Join-Path $imgDir ($name + '@2x.webp')

    if (-not (Test-Path $png)) { Write-Host "Arquivo ausente, pulando:" $png; continue }

    if ($hasMagick) {
        Write-Host "Usando magick para converter" $png
        Try-Run magick "`"$png`" -quality 75 `"$webp`""
        if (Test-Path $png2) { Try-Run magick "`"$png2`" -quality 75 `"$webp2`"" }
        continue
    }

    if ($hasCwebp) {
        Write-Host "Usando cwebp para converter" $png
        Try-Run cwebp "-q 75 `"$png`" -o `"$webp`""
        if (Test-Path $png2) { Try-Run cwebp "-q 75 `"$png2`" -o `"$webp2`"" }
        continue
    }

    if ($hasPython) {
        $py = (Get-Command python -ErrorAction SilentlyContinue).Source
        if (-not $py) { $py = (Get-Command python3 -ErrorAction SilentlyContinue).Source }
        Write-Host "Usando Python (Pillow) para converter" $png
        $script = @"
from PIL import Image
import sys
infile = sys.argv[1]
outfile = sys.argv[2]
im = Image.open(infile).convert('RGBA')
im.save(outfile, 'WEBP', quality=75, method=6)
"@
        $tmp = [System.IO.Path]::GetTempFileName() + '.py'
        Set-Content -Path $tmp -Value $script -Encoding UTF8
        & $py $tmp $png $webp
        if (Test-Path $png2) { & $py $tmp $png2 $webp2 }
        Remove-Item $tmp -ErrorAction SilentlyContinue
        continue
    }

    Write-Host "Nenhum conversor disponível (magick/cwebp/python). Instale um para gerar WebP ou o browser usará PNG. Pulando" $name
}

Write-Host "Converão para WebP finalizada (ou pulada quando não disponível)."
