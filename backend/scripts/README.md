# Backend Scripts

## Password Migration Script

### Purpose
Converts any existing plaintext passwords in the database to secure bcrypt hashes.

### When to Run
- **Once** before deploying to production
- After importing legacy user data
- If you have any users with plaintext passwords

### How to Run

```bash
# From project root
php backend/scripts/migrate_passwords.php
```

### What It Does
1. Scans all users in the database
2. Identifies passwords that are not bcrypt hashed
3. Hashes plaintext passwords using bcrypt
4. Updates the database with hashed passwords
5. Skips passwords that are already hashed

### Output Example
```
Starting password migration...
✓ Migrated password for user: user1@example.com
✓ Migrated password for user: user2@example.com
✓ Skipping user admin@example.com (already hashed)

=== Migration Complete ===
Migrated: 2 users
Skipped: 1 users (already hashed)
Total: 3 users
```

### Safety
- **Idempotent**: Safe to run multiple times
- **Non-destructive**: Only updates plaintext passwords
- **Automatic detection**: Identifies bcrypt hashes by prefix ($2y$, $2a$, $2b$)

### After Migration
- All users can login with their existing passwords
- Passwords are now securely hashed
- Login endpoints only accept bcrypt verification

### Troubleshooting

**Error: Database connection failed**
- Check `backend/config/database.php` configuration
- Ensure database server is running
- Verify credentials

**Error: Permission denied**
- Ensure PHP has write access to database
- Check database user permissions

**No users migrated**
- All passwords may already be hashed (this is good!)
- Check output for "Skipped" count

### Notes
- This script is required after the security fixes
- New user registrations automatically use bcrypt
- Login endpoints no longer accept plaintext passwords
