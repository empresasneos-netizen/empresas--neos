$files = @('logo2.png','vava.png','cs2.png','blod.png','far.png')
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$srcDir = Join-Path $scriptDir '..\images' | Resolve-Path
$outDir = Join-Path $srcDir 'opt'
if (-not (Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir | Out-Null }

Add-Type -AssemblyName System.Drawing

foreach ($f in $files) {
    $src = Join-Path $srcDir $f
    if (-not (Test-Path $src)) { Write-Host "Arquivo não encontrado: $src"; continue }
    $img = [System.Drawing.Image]::FromFile($src)
    $max = 300
    if ($f -like '*logo*') { $max = 120 }
    $ratioW = $max / $img.Width
    $ratioH = $max / $img.Height
    $ratio = [math]::Min($ratioW, $ratioH)
    if ($ratio -ge 1) { $nw = $img.Width; $nh = $img.Height } else { $nw = [int]($img.Width * $ratio); $nh = [int]($img.Height * $ratio) }

    $bmp = New-Object System.Drawing.Bitmap $nw, $nh
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $g.DrawImage($img, 0, 0, $nw, $nh)

    $out = Join-Path $outDir ([System.IO.Path]::GetFileNameWithoutExtension($f) + '.png')
    $bmp.Save($out, [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose(); $bmp.Dispose(); $img.Dispose()
    Write-Host "Salvo: $out"
}
Write-Host 'Redimensionamento concluído.'
