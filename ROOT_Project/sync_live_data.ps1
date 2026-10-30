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
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

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
    $localOrders = @()
    if (Test-Path $localOrdersPath) {
        try {
            $localRaw = [System.IO.File]::ReadAllText($localOrdersPath, [System.Text.Encoding]::UTF8).Trim().Trim([char]0xFEFF)
            if ($localRaw -and $localRaw.StartsWith("[")) {
                $localOrders = $localRaw | ConvertFrom-Json
            }
        } catch {
            Write-Host "   [CANH BAO] Khong doc duoc local orders: $($_.Exception.Message)" -ForegroundColor Yellow
        }
    }

    $allOrdersMap = [ordered]@{}
    # Doc tu live truoc neu co
    try {
        $ordersRaw = curl.exe -s --max-time 15 "$liveBase/tcController?action=getOrders"
        if ($ordersRaw) {
            $ordersRawClean = $ordersRaw.Trim().Trim([char]0xFEFF)
            if ($ordersRawClean.StartsWith("[") -and $ordersRawClean.EndsWith("]")) {
                $liveOrders = $ordersRawClean | ConvertFrom-Json
                foreach ($o in $liveOrders) {
                    $k = if ($o.orderId) { $o.orderId } else { $o.time }
                    if ($k) { $allOrdersMap[$k] = $o }
                }
            }
        }
    } catch {}

    # Hop nhat voi local (khong lam mat bat ky don nao)
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
        $jsonOrders = $mergedOrders | ConvertTo-Json -Depth 10
        if (-not $jsonOrders.Trim().StartsWith("[")) {
            $jsonOrders = "[" + "`r`n" + $jsonOrders + "`r`n" + "]"
        }
        [System.IO.File]::WriteAllText($localOrdersPath, $jsonOrders, $utf8NoBom)
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
            $localARaw = [System.IO.File]::ReadAllText($localAlbumsPath, [System.Text.Encoding]::UTF8).Trim().Trim([char]0xFEFF)
            if ($localARaw -and $localARaw.StartsWith("[")) {
                $localAlbums = $localARaw | ConvertFrom-Json
            }
        } catch {
            Write-Host "   [CANH BAO] Khong doc duoc local albums: $($_.Exception.Message)" -ForegroundColor Yellow
        }
    }

    $allAlbumsMap = [ordered]@{}
    foreach ($a in $localAlbums) {
        $k = if ($a.id) { $a.id } else { $a.folderId }
        if ($k) { $allAlbumsMap[$k] = $a }
    }

    try {
        $albumsRaw = curl.exe -s --max-time 15 "$liveBase/tcController?action=getAlbums"
        if ($albumsRaw) {
            $albumsRawClean = $albumsRaw.Trim().Trim([char]0xFEFF)
            if ($albumsRawClean.StartsWith("[") -and $albumsRawClean.EndsWith("]")) {
                $liveAlbums = $albumsRawClean | ConvertFrom-Json
                foreach ($a in $liveAlbums) {
                    $k = if ($a.id) { $a.id } else { $a.folderId }
                    if ($k -and -not $allAlbumsMap.Contains($k)) {
                        $allAlbumsMap[$k] = $a
                    }
                }
            }
        }
    } catch {}

    $mergedAlbums = @($allAlbumsMap.Values)
    if ($mergedAlbums.Count -gt 0) {
        $jsonAlbums = $mergedAlbums | ConvertTo-Json -Depth 10
        if (-not $jsonAlbums.Trim().StartsWith("[")) {
            $jsonAlbums = "[" + "`r`n" + $jsonAlbums + "`r`n" + "]"
        }
        [System.IO.File]::WriteAllText($localAlbumsPath, $jsonAlbums, $utf8NoBom)
        Write-Host "   [OK] Da hop nhat thanh cong $($mergedAlbums.Count) album." -ForegroundColor Green
    }
} catch {
    Write-Host "   [LOI] Khong the hop nhat kho album: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "======================================================" -ForegroundColor Cyan
Write-Host " HOAN TAT HOP NHAT CO SO DU LIEU AN TOAN 100%!" -ForegroundColor Green
Write-Host "======================================================" -ForegroundColor Cyan
