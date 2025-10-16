<!-- Notification Modal -->
<div class="modal fade" id="notificationModal" tabindex="-1" aria-labelledby="notificationModalLabel"
    aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title d-flex align-items-center" id="notificationModalLabel">
                    <i id="notificationIcon" class="me-2"></i>
                    <span id="notificationTitle">\u0054\u0068\u00F4\u006E\u0067\u0020\u0062\u00E1\u006F</span>
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p id="notificationMessage" class="mb-0"></p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" id="modalCloseBtn"></button>
            </div>
        </div>
    </div>
</div>

<script>
    function showNotification(type, message, title = '\u0054\u0068\u00F4\u006E\u0067\u0020\u0062\u00E1\u006F') {
        console.log('showNotification called with:', type, message, title);

        const modal = document.getElementById('notificationModal');
        if (!modal) {
            console.error('Modal not found');
            return;
        }

        const modalTitle = document.getElementById('notificationTitle');
        const modalMessage = document.getElementById('notificationMessage');
        const modalIcon = document.getElementById('notificationIcon');
        const modalHeader = modal.querySelector('.modal-header');

        // Set title and message
        modalTitle.textContent = title;
        modalMessage.textContent = message;

        // Remove existing classes
        modalHeader.className = 'modal-header';
        modalIcon.className = 'me-2';

        // Set colors and icons based on type
        switch (type) {
            case 'success':
                modalHeader.classList.add('bg-success', 'text-white');
                modalIcon.classList.add('bi', 'bi-check-circle-fill');
                break;
            case 'error':
            case 'danger':
                modalHeader.classList.add('bg-danger', 'text-white');
                modalIcon.classList.add('bi', 'bi-exclamation-triangle-fill');
                break;
            case 'warning':
                modalHeader.classList.add('bg-warning', 'text-dark');
                modalIcon.classList.add('bi', 'bi-exclamation-triangle-fill');
                break;
            case 'info':
                modalHeader.classList.add('bg-info', 'text-white');
                modalIcon.classList.add('bi', 'bi-info-circle-fill');
                break;
            default:
                modalHeader.classList.add('bg-primary', 'text-white');
                modalIcon.classList.add('bi', 'bi-info-circle-fill');
        }

        // Show modal
        console.log('Attempting to show modal...');
        try {
            const bsModal = new bootstrap.Modal(modal);
            bsModal.show();
            console.log('Modal show() called successfully');
        } catch (error) {
            console.error('Error showing modal:', error);
            // Fallback: show as alert if modal fails
            alert(title + ': ' + message);
        }
    }

    // Auto-check flash messages when page loads
    document.addEventListener('DOMContentLoaded', function () {
        console.log('Notification modal loaded');

        // Set close button text
        const modalCloseBtn = document.getElementById('modalCloseBtn');
        if (modalCloseBtn) {
            modalCloseBtn.textContent = '\u0110\u00F3ng';
        }

        // Check for success message
        const successMessage = '${success}';
        console.log('Success message:', successMessage);
        if (successMessage && successMessage.trim() !== '' && successMessage !== 'null') {
            console.log('Showing success notification');
            showNotification('success', successMessage, '\u0054\u0068\u00E0\u006E\u0068\u0020\u0063\u00F4\u006E\u0067');
        }

        // Check for error message
        const errorMessage = '${error}';
        console.log('Error message:', errorMessage);
        if (errorMessage && errorMessage.trim() !== '' && errorMessage !== 'null') {
            console.log('Showing error notification');
            showNotification('error', errorMessage, '\u004C\u1ED7\u0069');
        }

        // Check for warning message
        const warningMessage = '${warning}';
        if (warningMessage && warningMessage.trim() !== '' && warningMessage !== 'null') {
            showNotification('warning', warningMessage, '\u0043\u1EA3\u006E\u0068\u0020\u0062\u00E1\u006F');
        }

        // Check for info message
        const infoMessage = '${info}';
        if (infoMessage && infoMessage.trim() !== '' && infoMessage !== 'null') {
            showNotification('info', infoMessage, '\u0054\u0068\u00F4\u006E\u0067\u0020\u0074\u0069\u006E');
        }
    });
</script>