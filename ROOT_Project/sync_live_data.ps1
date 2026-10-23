# Script tu dong lay co so du lieu song tu he thong Render truoc khi dong goi
$ErrorActionPreference = "Continue"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$webInfDir = Join-Path $scriptDir "WEB-INF"
$backupDir = Join-Path $scriptDir "data_backups"

if (!(Test-Path $backupDir)) {
    New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
}

$nowStr = Get-Date -Format "yyyyMMdd_HHmmss"

# 1. Sao luu ban hien tai trong may truoc
$localOrdersPath = Join-Path $webInfDir "orders.json"
$localAlbumsPath = Join-Path $webInfDir "albums.json"

if (Test-Path $localOrdersPath) {
    Copy-Item $localOrdersPath (Join-Path $backupDir "orders_$nowStr.json") -Force
}
if (Test-Path $localAlbumsPath) {
    Copy-Item $localAlbumsPath (Join-Path $backupDir "albums_$nowStr.json") -Force
}

$liveBase = "https://web-lay-anh-2jjf.onrender.com"
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host " [QUY TAC HE THONG] DONG BO CO SO DU LIEU SONG TU SERVER" -ForegroundColor Yellow
Write-Host " Ket noi den: $liveBase" -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan

# 2. Keo don hang song
try {
    Write-Host "-> Dang lay danh sach Don Hang song tu server..."
    $ordersRaw = curl.exe -s --max-time 15 "$liveBase/tcController?action=getOrders"
    if ($ordersRaw -and $ordersRaw.Trim().StartsWith("[") -and $ordersRaw.Trim().EndsWith("]")) {
        $ordersObj = $ordersRaw | ConvertFrom-Json
        if ($ordersObj -and $ordersObj.Count -gt 0) {
            [System.IO.File]::WriteAllText($localOrdersPath, ($ordersObj | ConvertTo-Json -Depth 10), [System.Text.Encoding]::UTF8)
            Write-Host "   [OK] Da cap nhat $localOrdersPath ($($ordersObj.Count) don hang song)." -ForegroundColor Green
        }
    } else {
        Write-Host "   [BO QUA] Server khong tra ve mang JSON don hang hop le (co the do server dang khoi dong)." -ForegroundColor DarkYellow
    }
} catch {
    Write-Host "   [LOI] Khong the tai don hang tu server: $($_.Exception.Message)" -ForegroundColor Red
}

# 3. Keo kho album song
try {
    Write-Host "-> Dang lay danh sach Kho Album song tu server..."
    $albumsRaw = curl.exe -s --max-time 15 "$liveBase/tcController?action=getAlbums"
    if ($albumsRaw -and $albumsRaw.Trim().StartsWith("[") -and $albumsRaw.Trim().EndsWith("]") -and $albumsRaw.Length -gt 10) {
        $albumsObj = $albumsRaw | ConvertFrom-Json
        if ($albumsObj -and $albumsObj.Count -gt 0) {
            [System.IO.File]::WriteAllText($localAlbumsPath, ($albumsObj | ConvertTo-Json -Depth 10), [System.Text.Encoding]::UTF8)
            Write-Host "   [OK] Da cap nhat $localAlbumsPath ($($albumsObj.Count) album song)." -ForegroundColor Green
        }
    } else {
        Write-Host "   -> Thu lay tu Backup Google Sheet URL..."
        $sheetUrl = "https://script.google.com/macros/s/AKfycbxd8IxMapCIxdAGCZdz2Lsr9aIJYMcdmFI7Tl1eXJbMpmr-qHd8Tn3es2Gj-5zXxInr/exec?action=getAdminData"
        $backupRaw = curl.exe -s -L --max-time 15 $sheetUrl
        if ($backupRaw -and $backupRaw.Trim().StartsWith("[") -and $backupRaw.Trim().EndsWith("]")) {
            $sheetObj = $backupRaw | ConvertFrom-Json
            if ($sheetObj -and $sheetObj.Count -gt 0) {
                [System.IO.File]::WriteAllText($localAlbumsPath, ($sheetObj | ConvertTo-Json -Depth 10), [System.Text.Encoding]::UTF8)
                Write-Host "   [OK] Da cap nhat kho album tu Google Sheets ($($sheetObj.Count) album)." -ForegroundColor Green
            }
        }
    }
} catch {
    Write-Host "   [LOI] Khong the tai kho album: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "======================================================" -ForegroundColor Cyan
Write-Host " HOAN TAT DONG BO CO SO DU LIEU SAN SANG DONG GOI!" -ForegroundColor Green
Write-Host "======================================================" -ForegroundColor Cyan
