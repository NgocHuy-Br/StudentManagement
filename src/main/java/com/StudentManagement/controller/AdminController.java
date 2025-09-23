package com.StudentManagement.controller;

import com.StudentManagement.entity.User;
import com.StudentManagement.repository.UserRepository;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/admin")
public class AdminController {

    private final UserRepository userRepository;

    public AdminController(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @GetMapping
    public String index(Authentication auth, Model model) {
        String firstName = "User";
        String roleDisplay = "Người dùng";

        if (auth != null) {
            String username = auth.getName();
            User user = userRepository.findByUsername(username).orElse(null);
            if (user != null) {
                firstName = (user.getFname() != null && !user.getFname().isBlank())
                        ? user.getFname()
                        : user.getUsername();

                roleDisplay = switch (user.getRole()) {
                    case ADMIN -> "Quản trị viên";
                    case TEACHER -> "Giáo viên";
                    case STUDENT -> "Sinh viên";
                };
            }
        }

        model.addAttribute("firstName", firstName);
        model.addAttribute("roleDisplay", roleDisplay);
        return "admin/index"; // /WEB-INF/views/admin/index.jsp
    }
}