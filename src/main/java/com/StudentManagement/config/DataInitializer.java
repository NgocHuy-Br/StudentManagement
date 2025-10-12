package com.StudentManagement.config;

import com.StudentManagement.entity.User;
import com.StudentManagement.repository.UserRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

/**
 * Component để khởi tạo dữ liệu mặc định khi ứng dụng start up
 * Tự động tạo tài khoản admin nếu chưa có admin nào trong hệ thống
 */
@Component
public class DataInitializer implements CommandLineRunner {

    private static final Logger logger = LoggerFactory.getLogger(DataInitializer.class);

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) throws Exception {
        createDefaultAdminIfNotExists();
    }

    /**
     * Tạo tài khoản admin mặc định nếu chưa có admin nào trong hệ thống
     */
    private void createDefaultAdminIfNotExists() {
        try {
            // Kiểm tra xem đã có admin nào chưa
            boolean hasAdmin = userRepository.existsByRole(User.Role.ADMIN);

            if (!hasAdmin) {
                logger.info("Không tìm thấy tài khoản Admin nào trong hệ thống. Đang tạo tài khoản Admin mặc định...");

                // Tạo user admin mặc định
                User adminUser = new User();
                adminUser.setUsername("admin");
                adminUser.setPassword(passwordEncoder.encode("admin")); // Mật khẩu mặc định là "admin"
                adminUser.setFname("Administrator");
                adminUser.setLname("System");
                adminUser.setEmail("admin@system.com");
                adminUser.setRole(User.Role.ADMIN);

                // Lưu vào database
                userRepository.save(adminUser);

                logger.info("✅ Đã tạo thành công tài khoản Admin mặc định:");
                logger.info("   👤 Username: admin");
                logger.info("   🔐 Password: admin");
                logger.info("   📧 Email: admin@system.com");
                logger.info("   ⚠️  Vui lòng đổi mật khẩu sau khi đăng nhập lần đầu!");

            } else {
                logger.info("Đã có tài khoản Admin trong hệ thống. Không cần tạo Admin mặc định.");
                logger.info("💡 Nếu quên mật khẩu Admin, hãy liên hệ với quản trị viên hệ thống.");
            }

        } catch (Exception e) {
            logger.error("❌ Lỗi khi tạo tài khoản Admin mặc định: " + e.getMessage(), e);
        }
    }
}