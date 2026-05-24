#Requires -Version 5.1
<#
.SYNOPSIS
    Cut a video between two timestamps using ffmpeg.
.DESCRIPTION
    Interactively prompts for an input video file and start/end timestamps,
    then uses ffmpeg to extract the clip without re-encoding.
#>

function ConvertTo-Seconds {
    param ([string]$TimeStr)
    $parts = $TimeStr -split ':'
    if ($parts.Count -ne 3) { throw "Invalid time format '$TimeStr'. Expected HH:MM:SS." }
    [int]$h, [int]$m, [int]$s = $parts
    return $h * 3600 + $m * 60 + $s
}

function Invoke-VideoCut {
    param (
        [string]$InputPath,
        [string]$OutputPath,
        [string]$StartTime,
        [string]$EndTime
    )

    $startSec = ConvertTo-Seconds $StartTime
    $endSec   = ConvertTo-Seconds $EndTime

    if ($endSec -le $startSec) {
        throw "End time must be after start time."
    }

    $outputDir = Split-Path $OutputPath -Parent
    if ($outputDir -and -not (Test-Path $outputDir)) {
        New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
    }

    # -ss before -i = fast seek; -to is end timestamp; -c copy = no re-encode
    $duration = $endSec - $startSec
    & ffmpeg -y -ss $startSec -i $InputPath -t $duration -c copy $OutputPath
    if ($LASTEXITCODE -ne 0) { throw "ffmpeg exited with code $LASTEXITCODE." }
}

# ── Interactive prompts ────────────────────────────────────────────────────────

Write-Host "`n=== MediaForge Video Cutter ===" -ForegroundColor Cyan

do {
    $inputPath = Read-Host "Input video file path"
    $inputPath = $inputPath.Trim('"').Trim("'")
    if (-not (Test-Path $inputPath)) {
        Write-Warning "File not found: $inputPath"
    }
} until (Test-Path $inputPath)

$startTime = Read-Host "Start time (HH:MM:SS)"
$endTime   = Read-Host "End time   (HH:MM:SS)"

# Build a default output name: <basename>_<start>-<end>.mp4
$baseName   = [System.IO.Path]::GetFileNameWithoutExtension($inputPath)
$ext        = [System.IO.Path]::GetExtension($inputPath)
$safeStart  = $startTime -replace ':', '-'
$safeEnd    = $endTime   -replace ':', '-'
$defaultOut = "output\${baseName}_${safeStart}_${safeEnd}${ext}"

$outputPath = Read-Host "Output path (press Enter for '$defaultOut')"
if ([string]::IsNullOrWhiteSpace($outputPath)) { $outputPath = $defaultOut }
$outputPath = $outputPath.Trim('"').Trim("'")

# ── Execute ────────────────────────────────────────────────────────────────────

try {
    Write-Host "`nCutting video..." -ForegroundColor Yellow
    Invoke-VideoCut -InputPath $inputPath -OutputPath $outputPath `
                    -StartTime $startTime -EndTime $endTime
    Write-Host "Done! Saved to: $outputPath" -ForegroundColor Green
} catch {
    Write-Error $_.Exception.Message
    exit 1
}
