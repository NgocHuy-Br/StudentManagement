package com.StudentManagement.controller;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class AuthController {

    @GetMapping("/auth/login")
    public String loginPage() {
        return "login"; // /WEB-INF/views/login.jsp
    }

    @GetMapping("/welcome")
    public String welcome(Authentication auth, Model model) {
        String role = auth.getAuthorities().stream()
                .map(GrantedAuthority::getAuthority).findFirst().orElse("ROLE_USER");
        String roleDisplay = switch (role) {
            case "ROLE_ADMIN" -> "Quản trị viên";
            case "ROLE_TEACHER" -> "Giảng viên";
            case "ROLE_STUDENT" -> "Sinh viên";
            default -> "Người dùng";
        };
        model.addAttribute("roleDisplay", roleDisplay);
        model.addAttribute("username", auth.getName());
        return "welcome";
    }
}