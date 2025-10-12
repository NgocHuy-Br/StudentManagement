-- Add birth_date column to users table if it doesn't exist
ALTER TABLE users 
ADD COLUMN IF NOT EXISTS birth_date DATE COMMENT 'Ngày sinh của người dùng';

-- Update some sample birth dates for existing users (optional)
-- UPDATE users SET birth_date = '1990-01-01' WHERE username = 'admin' AND birth_date IS NULL;
-- UPDATE users SET birth_date = '1985-05-15' WHERE role = 'TEACHER' AND birth_date IS NULL LIMIT 1;
-- UPDATE users SET birth_date = '2000-03-20' WHERE role = 'STUDENT' AND birth_date IS NULL LIMIT 1;