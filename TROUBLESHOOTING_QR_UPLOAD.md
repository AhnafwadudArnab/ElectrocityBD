# QR Code Upload Troubleshooting Guide

## Issue: "Invalid response format (expected JSON)" Error

### Step 1: Check Database Table

Run this SQL in phpMyAdmin:

```sql
CREATE TABLE IF NOT EXISTS site_settings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    setting_key VARCHAR(100) UNIQUE NOT NULL,
    setting_value TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### Step 2: Check Uploads Directory

Ensure the directory exists and has write permissions:

```bash
# Create directory if it doesn't exist
mkdir -p backend/public/uploads

# Set permissions (Linux/Mac)
chmod 777 backend/public/uploads

# Windows: Right-click folder → Properties → Security → Edit → Add write permissions
```

### Step 3: Test Upload Endpoint

Test the upload API directly:

```bash
curl -X POST http://localhost:8000/api/upload \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -F "image=@/path/to/test-image.jpg"
```

Expected response:
```json
{
  "success": true,
  "url": "/uploads/img_xxxxx.jpg",
  "message": "Image uploaded successfully"
}
```

### Step 4: Test Site Settings Endpoint

Test saving settings:

```bash
curl -X POST http://localhost:8000/api/site_settings \
  -H "Content-Type: application/json" \
  -d '{"setting_key":"qr_code_image","setting_value":"test_value"}'
```

Expected response:
```json
{
  "success": true,
  "message": "Setting saved",
  "setting_key": "qr_code_image"
}
```

### Step 5: Check PHP Error Logs

Check `backend/error.log` for any PHP errors:

```bash
tail -f backend/error.log
```

### Step 6: Verify File Upload Settings

Check `php.ini` settings:

```ini
upload_max_filesize = 10M
post_max_size = 10M
file_uploads = On
```

### Step 7: Check Browser Console

Open browser DevTools (F12) → Console tab and look for errors when uploading.

### Step 8: Check Network Tab

Open browser DevTools (F12) → Network tab:
1. Try uploading again
2. Click on the upload request
3. Check Response tab for actual error message

## Common Issues

### Issue: "No file uploaded"
- **Cause**: Image picker not working
- **Solution**: Ensure `image_picker` package is installed and permissions are granted

### Issue: "File too large"
- **Cause**: Image exceeds 5MB limit
- **Solution**: Compress image or increase limit in `backend/config.php`

### Issue: "Invalid file type"
- **Cause**: File extension not allowed
- **Solution**: Only jpg, jpeg, png, webp are allowed

### Issue: "Failed to save image"
- **Cause**: Directory permissions
- **Solution**: Set uploads directory to 777 (or appropriate permissions)

### Issue: "Upload failed: 500"
- **Cause**: Server error
- **Solution**: Check `backend/error.log` for details

## Manual Testing

### Test 1: Check if uploads directory exists

```bash
ls -la backend/public/uploads/
```

Should show directory with write permissions.

### Test 2: Manually create test file

```bash
echo "test" > backend/public/uploads/test.txt
```

If this fails, permissions are wrong.

### Test 3: Check if site_settings table exists

```sql
SHOW TABLES LIKE 'site_settings';
```

Should return the table name.

### Test 4: Check table structure

```sql
DESCRIBE site_settings;
```

Should show: id, setting_key, setting_value, created_at, updated_at

## Still Not Working?

1. Check browser console for JavaScript errors
2. Check network tab for actual API response
3. Check backend error logs
4. Verify database connection
5. Test with a different image file
6. Try uploading a smaller image (< 1MB)
7. Clear browser cache and try again

## Success Indicators

When working correctly, you should see:

1. ✅ Image preview shows selected image
2. ✅ "Upload QR Code" button is enabled
3. ✅ Upload shows progress
4. ✅ Success message appears
5. ✅ Image appears in footer section
6. ✅ Refreshing page still shows the image

## Contact Support

If issue persists, provide:
- Browser console errors
- Network tab response
- Backend error.log content
- PHP version
- Database type and version
