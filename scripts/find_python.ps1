$paths = @(
  'C:\Users\rafae\AppData\Local\Programs\Python',
  'C:\Program Files\Python',
  'C:\Program Files\Python311',
  'C:\Program Files (x86)\Python',
  'C:\Program Files (x86)'
)
$found = $null
foreach($p in $paths){
  if(Test-Path $p){
    try{
      $candidate = Get-ChildItem -Path $p -Filter python.exe -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
      if($candidate){ $found = $candidate.FullName; break }
    } catch{}
  }
}
if($found){ Write-Host $found } else { Write-Host '' }
