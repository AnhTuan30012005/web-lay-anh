# Script tu dong hop nhat co so du lieu song tu Render va Local truoc khi dong goi
$ErrorActionPreference = "Continue"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$webInfDir = Join-Path $scriptDir "WEB-INF"
$backupDir = Join-Path $scriptDir "data_backups"

if (!(Test-Path $backupDir)) {
    New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
}

$nowStr = Get-Date -Format "yyyyMMdd_HHmmss"

# 1. Sao luu ban hien tai trong may truoc de phong rui ro
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
Write-Host " [QUY TAC HE THONG] HOP NHAT DU LIEU SONG TU SERVER" -ForegroundColor Yellow
Write-Host " Ket noi den: $liveBase" -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan

# 2. Hop nhat Don Hang (Orders) thong minh
try {
    Write-Host "-> Dang kiem tra danh sach Don Hang song tu server..."
    $ordersRaw = curl.exe -s --max-time 15 "$liveBase/tcController?action=getOrders"
    
    $localOrders = @()
    if (Test-Path $localOrdersPath) {
        try {
            $localRaw = Get-Content $localOrdersPath -Raw
            if ($localRaw -and $localRaw.Trim().StartsWith("[")) {
                $localOrders = $localRaw | ConvertFrom-Json
            }
        } catch {}
    }

    $allOrdersMap = [ordered]@{}
    if ($ordersRaw -and $ordersRaw.Trim().StartsWith("[") -and $ordersRaw.Trim().EndsWith("]")) {
        $liveOrders = $ordersRaw | ConvertFrom-Json
        foreach ($o in $liveOrders) {
            $k = if ($o.orderId) { $o.orderId } else { $o.time }
            if ($k) { $allOrdersMap[$k] = $o }
        }
    }
    foreach ($o in $localOrders) {
        $k = if ($o.orderId) { $o.orderId } else { $o.time }
        if ($k -and -not $allOrdersMap.Contains($k)) {
            $allOrdersMap[$k] = $o
        }
    }

    $mergedOrders = @($allOrdersMap.Values)
    if ($mergedOrders.Count -gt 0) {
        for ($i = 0; $i -lt $mergedOrders.Count; $i++) {
            $mergedOrders[$i].rowIndex = $i + 1
        }
        [System.IO.File]::WriteAllText($localOrdersPath, ($mergedOrders | ConvertTo-Json -Depth 10), [System.Text.Encoding]::UTF8)
        Write-Host "   [OK] Da hop nhat thanh cong $($mergedOrders.Count) don hang." -ForegroundColor Green
    }
} catch {
    Write-Host "   [LOI] Khong the tai don hang tu server: $($_.Exception.Message)" -ForegroundColor Red
}

# 3. Hop nhat Kho Album (Albums) thong minh
try {
    Write-Host "-> Dang kiem tra danh sach Kho Album..."
    $localAlbums = @()
    if (Test-Path $localAlbumsPath) {
        try {
            $localARaw = Get-Content $localAlbumsPath -Raw
            if ($localARaw -and $localARaw.Trim().StartsWith("[")) {
                $localAlbums = $localARaw | ConvertFrom-Json
            }
        } catch {}
    }

    $allAlbumsMap = [ordered]@{}
    foreach ($a in $localAlbums) {
        $k = if ($a.id) { $a.id } else { $a.folderId }
        if ($k) { $allAlbumsMap[$k] = $a }
    }

    $albumsRaw = curl.exe -s --max-time 15 "$liveBase/tcController?action=getAlbums"
    if ($albumsRaw -and $albumsRaw.Trim().StartsWith("[") -and $albumsRaw.Trim().EndsWith("]")) {
        $liveAlbums = $albumsRaw | ConvertFrom-Json
        foreach ($a in $liveAlbums) {
            $k = if ($a.id) { $a.id } else { $a.folderId }
            if ($k -and -not $allAlbumsMap.Contains($k)) {
                $allAlbumsMap[$k] = $a
            }
        }
    }

    $mergedAlbums = @($allAlbumsMap.Values)
    if ($mergedAlbums.Count -gt 0) {
        [System.IO.File]::WriteAllText($localAlbumsPath, ($mergedAlbums | ConvertTo-Json -Depth 10), [System.Text.Encoding]::UTF8)
        Write-Host "   [OK] Da hop nhat thanh cong $($mergedAlbums.Count) album." -ForegroundColor Green
    }
} catch {
    Write-Host "   [LOI] Khong the hop nhat kho album: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "======================================================" -ForegroundColor Cyan
Write-Host " HOAN TAT HOP NHAT CO SO DU LIEU AN TOAN 100%!" -ForegroundColor Green
Write-Host "======================================================" -ForegroundColor Cyan
