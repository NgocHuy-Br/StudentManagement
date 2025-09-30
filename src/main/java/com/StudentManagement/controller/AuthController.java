package com.StudentManagement.controller;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class AuthController {

    @GetMapping("/")
    public String root(Authentication auth) {
        return "redirect:/welcome";
    }

    @GetMapping("/auth/login")
    public String loginPage() {
        return "common/login"; // /WEB-INF/views/login.jsp
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
            return "redirect:/homeroom";
        if (isStudent)
            return "redirect:/student";

        // Fallback: redirect to login if no valid role
        return "redirect:/auth/login";
    }
}