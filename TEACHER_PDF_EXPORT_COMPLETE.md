# Teacher PDF Export - Hoàn Thành Chức Năng Xuất PDF Cho Giáo Viên

## Vấn Đề Đã Sửa

### **Before (Trước đây):**
- Teacher role không có chức năng xuất PDF hoặc gặp lỗi 400 Bad Request
- URL yêu cầu classroomId nhưng teacher không có cách để biết classroomId
- Logic export không consistent giữa Admin và Teacher

### **After (Sau khi sửa):**
- ✅ Teacher có chức năng xuất PDF hoàn chỉnh
- ✅ Auto-detect classroom của giáo viên đang chủ nhiệm
- ✅ Consistent data export logic với Admin role
- ✅ Support search và subject filtering

## Chi Tiết Kỹ Thuật

### A. Thêm Endpoint Mới Cho Teacher

#### **URL Mapping:**
```java
// OLD: Yêu cầu classroomId trong URL
@GetMapping("/classroom/{classroomId}/scores/export-pdf")

// NEW: Auto-detect classroom 
@GetMapping("/scores/export-pdf")
public ResponseEntity<byte[]> exportMyClassScoresPdf(
    @RequestParam(required = false) Long subjectId,
    @RequestParam(required = false) String search,
    Authentication auth) 
```

#### **Auto-Detection Logic:**
```java
// Tự động tìm lớp mà giáo viên đang phụ trách
List<Classroom> assignedClasses = classroomRepository.findByHomeRoomTeacher(teacher);
if (assignedClasses.isEmpty()) {
    return ResponseEntity.badRequest().build();
}

// Lấy lớp đầu tiên (giáo viên thường chỉ chủ nhiệm 1 lớp)
Classroom classroom = assignedClasses.get(0);
```

### B. Complete Data Export Logic

#### **Virtual Score Creation:**
```java
// Tạo tất cả combination sinh viên x môn học
for (Student student : students) {
    for (Subject subject : subjects) {
        Optional<Score> existingScoreOpt = scoreRepository
            .findByStudentIdAndSubjectId(student.getId(), subject.getId());
        
        if (existingScoreOpt.isPresent()) {
            scores.add(existingScoreOpt.get());  // Real score
        } else {
            // Virtual score với điểm null
            Score virtualScore = new Score();
            virtualScore.setStudent(student);
            virtualScore.setSubject(subject);
            virtualScore.setAttendanceScore(null);
            virtualScore.setMidtermScore(null);
            virtualScore.setFinalScore(null);
            virtualScore.setAvgScore(null);
            scores.add(virtualScore);
        }
    }
}
```

#### **Search Filtering Support:**
```java
// Lọc sinh viên theo tìm kiếm nếu có
if (search != null && !search.trim().isEmpty()) {
    String searchTerm = search.trim().toLowerCase();
    students = students.stream()
            .filter(student -> student.getUser().getUsername().toLowerCase().contains(searchTerm) ||
                    (student.getUser().getFname() + " " + student.getUser().getLname()).toLowerCase()
                            .contains(searchTerm))
            .collect(java.util.stream.Collectors.toList());
}
```

### C. Frontend Updates

#### **Updated JavaScript:**
```javascript
function exportToPdf() {
    // Không cần check classroomId nữa
    const subjectId = document.getElementById('subjectSelect').value;
    const search = document.getElementById('searchInput').value;

    // Check có dữ liệu không
    const hasData = document.querySelectorAll('#scoresTable tbody tr').length > 0;
    if (!hasData) {
        showNotification('error', 'Không có dữ liệu để xuất PDF', 'Lỗi');
        return;
    }

    // Tạo URL với parameters
    let url = '/teacher/scores/export-pdf';
    const params = new URLSearchParams();
    
    if (subjectId) {
        params.append('subjectId', subjectId);
    }
    if (search && search.trim()) {
        params.append('search', search.trim());
    }
    
    if (params.toString()) {
        url += '?' + params.toString();
    }

    // Download PDF
    window.open(url, '_blank');
}
```

#### **Updated Button:**
```html
<!-- Removed disabled condition và classroom requirement -->
<button type="button" class="btn btn-outline-danger"
        onclick="exportToPdf()"
        title="Xuất danh sách điểm ra file PDF">
    <i class="bi bi-file-earmark-pdf"></i> Xuất PDF
</button>
```

## So Sánh Admin vs Teacher

### **Admin Export Features:**
- ✅ Chọn bất kỳ lớp nào
- ✅ Chọn môn học hoặc tất cả môn
- ✅ Search students
- ✅ Export all data combinations
- ✅ Role-based access control

### **Teacher Export Features:**
- ✅ Auto-detect lớp được phân công
- ✅ Chọn môn học hoặc tất cả môn
- ✅ Search students
- ✅ Export all data combinations  
- ✅ Role-based access control
- ✅ Simplified UX (không cần chọn lớp)

## Shared Components

### **PdfService.java:**
- ✅ Same PDF generation logic
- ✅ Vietnamese font support
- ✅ Professional layout
- ✅ Handle virtual scores với "--"

### **Data Logic:**
- ✅ Same virtual score creation
- ✅ Same search filtering
- ✅ Same subject filtering
- ✅ Consistent PDF format

## URL Endpoints Summary

### **Admin PDF Export:**
```
GET /admin/scores/export-pdf
Parameters: classroomId, subjectId, search
```

### **Teacher PDF Export:**
```
GET /teacher/scores/export-pdf  
Parameters: subjectId, search (auto-detect classroomId)
```

## Test Scenarios for Teacher

1. **✅ Export tất cả môn học:** Teacher login → Scores page → Click "Xuất PDF"
2. **✅ Export môn học cụ thể:** Chọn môn → Click "Xuất PDF" 
3. **✅ Export với search:** Nhập tên sinh viên → Click "Xuất PDF"
4. **✅ Export combo filter:** Chọn môn + search → Click "Xuất PDF"
5. **✅ Virtual scores:** Môn chưa có điểm hiển thị "--"
6. **✅ Role security:** Teacher chỉ xuất được lớp được assign

## Error Handling

### **Teacher Not Assigned:**
- Return 400 Bad Request nếu teacher không có lớp nào
- Clear error message cho user

### **No Data:**
- Frontend validation: Check có data trong table không
- Show notification nếu không có data để export

### **Permission:**
- Backend validation: Check teacher có phải homeroom của lớp không
- Prevent unauthorized access

---

**Kết luận:** Teacher PDF export đã hoàn thiện với đầy đủ tính năng tương đương Admin, UI/UX đơn giản hơn (auto-detect classroom), và an toàn với role-based access control.