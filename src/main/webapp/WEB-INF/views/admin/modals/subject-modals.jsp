<!-- Create Subject Modal -->
<div class="modal fade" id="modalCreateSubject" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="bi bi-plus-circle me-2"></i>Thêm môn học mới
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form method="post" action="/admin/subjects">
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="createSubjectCode" class="form-label">Mã môn học <span
                                class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="createSubjectCode" name="subjectCode" required>
                    </div>
                    <div class="mb-3">
                        <label for="createSubjectName" class="form-label">Tên môn học <span
                                class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="createSubjectName" name="subjectName" required>
                    </div>
                    <div class="mb-3">
                        <label for="createSubjectCredit" class="form-label">Số tín chỉ <span
                                class="text-danger">*</span></label>
                        <input type="number" class="form-control" id="createSubjectCredit" name="credit" min="1"
                            max="10" required>
                    </div>
                    <input type="hidden" name="majorId" value="${selectedMajor.id}">
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-check-lg me-1"></i>Thêm môn học
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Edit Subject Modal -->
<div class="modal fade" id="modalEditSubject" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="bi bi-pencil me-2"></i>Chỉnh sửa môn học
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form method="post" id="editSubjectForm">
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="editSubjectCode" class="form-label">Mã môn học <span
                                class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="editSubjectCode" name="subjectCode" required>
                    </div>
                    <div class="mb-3">
                        <label for="editSubjectName" class="form-label">Tên môn học <span
                                class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="editSubjectName" name="subjectName" required>
                    </div>
                    <div class="mb-3">
                        <label for="editSubjectCredit" class="form-label">Số tín chỉ <span
                                class="text-danger">*</span></label>
                        <input type="number" class="form-control" id="editSubjectCredit" name="credit" min="1" max="10"
                            required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-check-lg me-1"></i>Cập nhật
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Delete Subject Modal -->
<div class="modal fade" id="modalDeleteSubject" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title text-danger">
                    <i class="bi bi-exclamation-triangle me-2"></i>Xác nhận xóa
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p>Bạn có chắc chắn muốn xóa môn học <strong id="deleteSubjectName"></strong> không?</p>
                <div class="alert alert-warning">
                    <i class="bi bi-exclamation-triangle me-2"></i>
                    <strong>Lưu ý:</strong> Việc xóa môn học có thể ảnh hưởng đến dữ liệu điểm số và phân công giảng
                    dạy.
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                <form method="post" id="deleteSubjectForm" class="d-inline">
                    <button type="submit" class="btn btn-danger">
                        <i class="bi bi-trash me-1"></i>Xóa môn học
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>