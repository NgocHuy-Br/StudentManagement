<!-- Create Major Modal -->
<div class="modal fade" id="modalCreateMajor" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="bi bi-plus-circle me-2"></i>Thêm ngành mới
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form method="post" action="/admin/majors">
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="createMajorCode" class="form-label">Mã ngành <span
                                class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="createMajorCode" name="majorCode" required>
                    </div>
                    <div class="mb-3">
                        <label for="createMajorName" class="form-label">Tên ngành <span
                                class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="createMajorName" name="majorName" required>
                    </div>
                    <div class="mb-3">
                        <label for="createMajorDescription" class="form-label">Mô tả</label>
                        <textarea class="form-control" id="createMajorDescription" name="description" rows="3"
                            placeholder="Mô tả về ngành (tùy chọn)"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-success">
                        <i class="bi bi-check-lg me-1"></i>Thêm ngành
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Edit Major Modal -->
<div class="modal fade" id="modalEditMajor" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="bi bi-pencil me-2"></i>Chỉnh sửa ngành
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form method="post" id="editMajorForm">
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="editMajorCode" class="form-label">Mã ngành <span
                                class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="editMajorCode" name="majorCode" required>
                    </div>
                    <div class="mb-3">
                        <label for="editMajorName" class="form-label">Tên ngành <span
                                class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="editMajorName" name="majorName" required>
                    </div>
                    <div class="mb-3">
                        <label for="editMajorDescription" class="form-label">Mô tả</label>
                        <textarea class="form-control" id="editMajorDescription" name="description" rows="3"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-success">
                        <i class="bi bi-check-lg me-1"></i>Cập nhật
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Delete Major Modal -->
<div class="modal fade" id="modalDeleteMajor" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title text-danger">
                    <i class="bi bi-exclamation-triangle me-2"></i>Xác nhận xóa
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p>Bạn có chắc chắn muốn xóa ngành <strong id="deleteMajorName"></strong> không?</p>
                <div class="alert alert-warning">
                    <i class="bi bi-exclamation-triangle me-2"></i>
                    <strong>Lưu ý:</strong> Việc xóa ngành sẽ ảnh hưởng đến các môn học và sinh viên thuộc ngành này.
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                <form method="post" id="deleteMajorForm" class="d-inline">
                    <button type="submit" class="btn btn-danger">
                        <i class="bi bi-trash me-1"></i>Xóa ngành
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>