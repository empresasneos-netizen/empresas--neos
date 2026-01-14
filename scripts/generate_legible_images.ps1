$files = @(
    @{name='logo2.png'; max=64},
    @{name='vava.png'; max=160},
    @{name='cs2.png'; max=160},
    @{name='blod.png'; max=160},
    @{name='far.png'; max=160}
)
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$srcDir = Join-Path $scriptDir '..\images' | Resolve-Path
$outDir = Join-Path $srcDir 'opt'
if (-not (Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir | Out-Null }

Add-Type -AssemblyName System.Drawing

foreach ($item in $files) {
    $f = $item.name
    $max = $item.max
    $src = Join-Path $srcDir $f
    if (-not (Test-Path $src)) { Write-Host "Arquivo não encontrado: $src"; continue }
    $img = [System.Drawing.Image]::FromFile($src)
    # 1x
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
    $g.Dispose(); $bmp.Dispose()

    # 2x
    $max2 = $max * 2
    $ratioW = $max2 / $img.Width
    $ratioH = $max2 / $img.Height
    $ratio = [math]::Min($ratioW, $ratioH)
    if ($ratio -ge 1) { $nw = $img.Width; $nh = $img.Height } else { $nw = [int]($img.Width * $ratio); $nh = [int]($img.Height * $ratio) }
    $bmp2 = New-Object System.Drawing.Bitmap $nw, $nh
    $g2 = [System.Drawing.Graphics]::FromImage($bmp2)
    $g2.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
    $g2.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g2.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $g2.DrawImage($img, 0, 0, $nw, $nh)
    $out2 = Join-Path $outDir ([System.IO.Path]::GetFileNameWithoutExtension($f) + '@2x.png')
    $bmp2.Save($out2, [System.Drawing.Imaging.ImageFormat]::Png)
    $g2.Dispose(); $bmp2.Dispose(); $img.Dispose()

    Write-Host "Gerados: $out e $out2"
}
Write-Host 'Versões legíveis geradas.'
