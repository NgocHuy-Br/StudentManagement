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
        if (auth == null)
            return "redirect:/auth/login";

        boolean isAdmin = auth.getAuthorities().stream().anyMatch(a -> "ROLE_ADMIN".equals(a.getAuthority()));
        boolean isTeacher = auth.getAuthorities().stream().anyMatch(a -> "ROLE_TEACHER".equals(a.getAuthority()));
        boolean isStudent = auth.getAuthorities().stream().anyMatch(a -> "ROLE_STUDENT".equals(a.getAuthority()));

        if (isAdmin)
            return "redirect:/admin";
        if (isTeacher)
            return "redirect:/teacher";
        if (isStudent)
            return "redirect:/student";

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
        return "welcome"; // fallback
    }
}