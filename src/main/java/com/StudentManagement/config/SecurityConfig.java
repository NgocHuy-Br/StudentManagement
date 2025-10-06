package com.StudentManagement.config;

import jakarta.servlet.DispatcherType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.core.userdetails.UserDetailsService;

import com.StudentManagement.service.CustomUserDetailsService;

@Configuration //thử với Huy//
@EnableWebSecurity
public class SecurityConfig {

        @Autowired
        private CustomUserDetailsService userDetailsService;

        @Bean
        public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
                http
                                .userDetailsService(userDetailsService)
                                .csrf(csrf -> csrf.disable())
                                .authorizeHttpRequests(auth -> auth
                                                // Cho phép các forward/error nội bộ (render JSP)
                                                .dispatcherTypeMatchers(DispatcherType.FORWARD, DispatcherType.ERROR)
                                                .permitAll()
                                                // Cho phép đường dẫn JSP nội bộ dưới WEB-INF khi forward
                                                .requestMatchers("/WEB-INF/**").permitAll()
                                                // Public endpoints
                                                .requestMatchers(
                                                                "/auth/login", "/auth/perform-login", "/error",
                                                                "/favicon.ico",
                                                                "/css/**", "/js/**", "/images/**", "/img/**",
                                                                "/webjars/**")
                                                .permitAll()
                                                // Role-based authorization
                                                .requestMatchers("/admin/**").hasRole("ADMIN")
                                                .requestMatchers("/teacher/**").hasRole("TEACHER")
                                                .requestMatchers("/student/**").hasRole("STUDENT")
                                                .anyRequest().authenticated())
                                .requestCache(cache -> cache.disable())
                                .formLogin(form -> form
                                                .loginPage("/login")
                                                .loginProcessingUrl("/perform-login")
                                                .usernameParameter("username")
                                                .passwordParameter("password")
                                                .defaultSuccessUrl("/welcome")
                                                .failureUrl("/login?error=true")
                                                .permitAll())
                                .logout(logout -> logout
                                                .logoutUrl("/logout")
                                                .logoutSuccessUrl("/login?logout=true")
                                                .permitAll());
                return http.build();
        }

        @Bean
        public PasswordEncoder passwordEncoder() {
                // LƯU: BCrypt; SO KHỚP: nếu encoded là BCrypt thì BCrypt.matches, nếu là
                // plain-text cũ thì equals
                return new BackwardCompatiblePasswordEncoder();
        }

        // Encoder tương thích ngược: encode = BCrypt, matches hỗ trợ cả BCrypt và
        // plain-text legacy
        static class BackwardCompatiblePasswordEncoder implements PasswordEncoder {
                private final BCryptPasswordEncoder bcrypt = new BCryptPasswordEncoder();

                @Override
                public String encode(CharSequence rawPassword) {
                        return rawPassword == null ? null : bcrypt.encode(rawPassword);
                }

                @Override
                public boolean matches(CharSequence rawPassword, String encodedPassword) {
                        if (rawPassword == null && encodedPassword == null)
                                return true;
                        if (rawPassword == null || encodedPassword == null)
                                return false;

                        // Nếu trong DB là hash BCrypt
                        if (isBcryptHash(encodedPassword)) {
                                return bcrypt.matches(rawPassword, encodedPassword);
                        }
                        // Legacy: plain-text (tạm thời hỗ trợ để không khóa tài khoản cũ)
                        return encodedPassword.equals(rawPassword.toString());
                }

                private boolean isBcryptHash(String s) {
                        // BCrypt chuẩn bắt đầu với $2a$, $2b$, $2y$
                        return s.startsWith("$2a$") || s.startsWith("$2b$") || s.startsWith("$2y$");
                }
        }
}