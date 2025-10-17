// SIMPLE SUBJECT REMOVAL FUNCTION
function handleSubjectRemoval(subjectId, subjectCode) {
    console.log('handleSubjectRemoval called with:', subjectId, subjectCode);

    // Get current context
    const urlParams = new URLSearchParams(window.location.search);
    const isViewAll = urlParams.get('viewAll') === 'true';
    const selectedMajorId = document.querySelector('input[name="majorId"]')?.value || '';

    // Set up modal content based on context
    const modal = document.getElementById('deleteSubjectModal');
    const form = document.getElementById('deleteSubjectForm');
    const message = document.getElementById('deleteSubjectMessage');
    const button = document.getElementById('deleteSubjectButton');
    const nameSpan = document.getElementById('deleteSubjectName');

    // Set subject name
    nameSpan.textContent = subjectCode;

    if (isViewAll || !selectedMajorId || selectedMajorId === '' || selectedMajorId === 'null') {
        // Complete deletion
        form.action = '/admin/subjects/delete';
        document.getElementById('deleteSubjectId').value = subjectId;
        document.getElementById('deleteSubjectIdParam').value = '';
        message.innerHTML = 'Bạn có chắc chắn muốn <strong>xóa hoàn toàn</strong> môn học <strong>' + subjectCode + '</strong>?<br><small class="text-danger">Lưu ý: Môn học sẽ bị xóa khỏi tất cả ngành học.</small>';
        button.textContent = 'Xóa hoàn toàn';
        button.className = 'btn btn-danger';
    } else {
        // Remove from major only
        form.action = '/admin/majors/' + selectedMajorId + '/subjects/delete';
        document.getElementById('deleteSubjectId').value = '';
        document.getElementById('deleteSubjectIdParam').value = subjectId;
        message.innerHTML = 'Bạn có chắc chắn muốn <strong>gỡ môn học</strong> <strong>' + subjectCode + '</strong> khỏi ngành này?<br><small class="text-info">Lưu ý: Môn học sẽ chỉ bị gỡ khỏi ngành này, không bị xóa hoàn toàn.</small>';
        button.textContent = 'Gỡ khỏi ngành';
        button.className = 'btn btn-warning';
    }

    // Show modal
    const bsModal = new bootstrap.Modal(modal);
    bsModal.show();
}

// MAJOR MANAGEMENT
document.addEventListener('DOMContentLoaded', function () {
    // Edit Major buttons
    document.querySelectorAll('.edit-major-btn').forEach(btn => {
        btn.addEventListener('click', function (e) {
            e.preventDefault();
            const id = this.dataset.id;
            const code = this.dataset.code;
            const name = this.dataset.name;
            const description = this.dataset.description || '';
            const facultyId = this.dataset.facultyId;

            document.getElementById('editMajorId').value = id;
            document.getElementById('editMajorFacultyId').value = facultyId;
            document.getElementById('editMajorCode').value = code;
            document.getElementById('editMajorName').value = name;
            document.getElementById('editMajorDescription').value = description;

            const editModal = new bootstrap.Modal(document.getElementById('editMajorModal'));
            editModal.show();
        });
    });

    // Delete Major buttons
    document.querySelectorAll('.delete-major-btn').forEach(btn => {
        btn.addEventListener('click', function (e) {
            e.preventDefault();
            const id = this.dataset.id;
            const name = this.dataset.name;

            document.getElementById('deleteMajorId').value = id;
            document.getElementById('deleteMajorName').textContent = name;

            const deleteModal = new bootstrap.Modal(document.getElementById('deleteMajorModal'));
            deleteModal.show();
        });
    });

    // Edit Subject buttons
    document.querySelectorAll('.edit-subject-btn').forEach(btn => {
        btn.addEventListener('click', function (e) {
            e.preventDefault();
            const id = this.dataset.id;
            const code = this.dataset.code;
            const name = this.dataset.name;
            const credit = this.dataset.credit;
            const attendanceWeight = this.dataset.attendanceWeight || '10';
            const midtermWeight = this.dataset.midtermWeight || '30';
            const finalWeight = this.dataset.finalWeight || '60';

            document.getElementById('editSubjectId').value = id;
            document.getElementById('editSubjectCode').value = code;
            document.getElementById('editSubjectName').value = name;
            document.getElementById('editSubjectCredit').value = credit;
            document.getElementById('editAttendanceWeight').value = attendanceWeight;
            document.getElementById('editMidtermWeight').value = midtermWeight;
            document.getElementById('editFinalWeight').value = finalWeight;

            const editModal = new bootstrap.Modal(document.getElementById('editSubjectModal'));
            editModal.show();
        });
    });
});