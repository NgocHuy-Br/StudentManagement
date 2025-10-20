# Teacher PDF Export Debug Guide

## Vấn Đề Hiện Tại
User báo lỗi "Không có dữ liệu để xuất PDF" khi click button "Xuất PDF" ở teacher interface.

## Đã Thực Hiện
1. ✅ Loại bỏ frontend validation tạm thời
2. ✅ Thêm debug logs trong backend
3. ✅ Thêm console.log trong frontend để track URL
4. ✅ Sửa endpoint để auto-detect classroom

## Debugging Steps

### 1. Kiểm tra Browser Console
Mở Developer Tools (F12) → Console tab, sau đó:
1. Click button "Xuất PDF" 
2. Xem console logs:
   - `Exporting PDF with URL: /teacher/scores/export-pdf`
   - Có error message nào không?

### 2. Kiểm tra Network Tab
Developer Tools → Network tab:
1. Click "Xuất PDF"
2. Xem request đến `/teacher/scores/export-pdf`
3. Status code là gì? (200, 400, 500?)
4. Response body chứa gì?

### 3. Kiểm tra Server Logs
Trong terminal running application, tìm:
```
DEBUG: Found X assigned classes for teacher Y
DEBUG: Using classroom Z - ClassCode
DEBUG: Found X students
```

## Possible Issues & Solutions

### Issue 1: Teacher không phải homeroom teacher
**Symptoms:** DEBUG logs show "Found 0 assigned classes"
**Solution:** Cần assign teacher làm homeroom cho lớp trong database

### Issue 2: URL routing issue  
**Symptoms:** 404 Not Found trong Network tab
**Solution:** Check request mapping

### Issue 3: Backend exception
**Symptoms:** 500 Internal Server Error
**Solution:** Check server logs cho stack trace

### Issue 4: PDF generation error
**Symptoms:** Request success nhưng không download
**Solution:** Check browser popup blocker

## Quick Test Commands

### Test URL trực tiếp:
```
http://localhost:8080/teacher/scores/export-pdf
```

### Test với parameters:
```  
http://localhost:8080/teacher/scores/export-pdf?subjectId=1
```

## Expected Behavior
1. Click "Xuất PDF" → Console log URL
2. Browser mở new tab/window
3. PDF file download tự động
4. PDF chứa tất cả students và subjects (có "--" cho empty scores)

## Quick Fixes if Needed

### If teacher not homeroom:
```sql
UPDATE classroom SET home_room_teacher_id = [teacher_id] WHERE id = 2;
```

### If URL issue:
Check @RequestMapping trong HomeRoomTeacherController

### If popup blocked:
Cho phép popup từ localhost trong browser settings