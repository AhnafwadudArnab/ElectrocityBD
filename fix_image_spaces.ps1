# PowerShell script to rename image files (remove spaces)
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Fixing Image Files with Spaces" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

$folders = @(
    "assets/trends",
    "assets/Deals of the Day",
    "assets/Collections/Kennede & Defender Charger Fan"
)

$renamedFiles = @()

foreach ($folder in $folders) {
    if (Test-Path $folder) {
        Write-Host "Processing folder: $folder" -ForegroundColor Yellow
        
        Get-ChildItem $folder -File | Where-Object { $_.Name -match ' ' } | ForEach-Object {
            $oldName = $_.Name
            $newName = $oldName -replace ' ', '_'
            $oldPath = $_.FullName
            $newPath = Join-Path $_.Directory $newName
            
            Write-Host "  Renaming: $oldName -> $newName" -ForegroundColor Green
            
            Rename-Item -Path $oldPath -NewName $newName -Force
            
            $renamedFiles += [PSCustomObject]@{
                Folder = $folder
                OldName = $oldName
                NewName = $newName
            }
        }
    }
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Summary: Renamed $($renamedFiles.Count) files" -ForegroundColor Green
Write-Host "========================================`n" -ForegroundColor Cyan

# Generate SQL update script
$sqlFile = "databaseMysql/update_image_paths_spaces.sql"
$sql = @"
-- Update database image paths to match renamed files
USE electrobd;

SELECT '============================================' as '';
SELECT 'Updating Image Paths (Removing Spaces)' as Status;
SELECT '============================================' as '';

"@

foreach ($file in $renamedFiles) {
    $oldPath = "$($file.Folder)/$($file.OldName)" -replace '\\', '/'
    $newPath = "$($file.Folder)/$($file.NewName)" -replace '\\', '/'
    
    $sql += @"

-- Update: $($file.OldName) -> $($file.NewName)
UPDATE products 
SET image_url = '$newPath'
WHERE image_url = '$oldPath';

"@
}

$sql += @"

SELECT '============================================' as '';
SELECT 'Image Paths Updated!' as Status;
SELECT '============================================' as '';

-- Verify updates
SELECT 'Updated paths:' as Info;
SELECT DISTINCT image_url 
FROM products 
WHERE image_url LIKE '%trends%' OR image_url LIKE '%Deals%'
ORDER BY image_url;
"@

$sql | Out-File -FilePath $sqlFile -Encoding UTF8

Write-Host "SQL update script created: $sqlFile" -ForegroundColor Cyan
Write-Host "`nNext step: Run the SQL script to update database" -ForegroundColor Yellow
Write-Host "Command: Get-Content $sqlFile | mysql -u root electrobd`n" -ForegroundColor White
