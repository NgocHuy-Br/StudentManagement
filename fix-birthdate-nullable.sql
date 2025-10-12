-- Fix birth_date column to allow NULL values
ALTER TABLE users MODIFY COLUMN birth_date DATE NULL;