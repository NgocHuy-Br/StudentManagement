package com.StudentManagement.config;

import jakarta.servlet.DispatcherType;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.NoOpPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

        @Bean
        public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
                http
                                .csrf(csrf -> csrf.disable())
                                .authorizeHttpRequests(auth -> auth
                                                // Cho phép các forward/error nội bộ (render JSP) để không bị chặn
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
                                                .anyRequest().authenticated())
                                // Tránh lưu request vào session gây rối khi render login.jsp
                                .requestCache(cache -> cache.disable())
                                .formLogin(form -> form
                                                .loginPage("/auth/login")
                                                .loginProcessingUrl("/auth/perform-login")
                                                .usernameParameter("username")
                                                .passwordParameter("password")
                                                .defaultSuccessUrl("/welcome") // không ép alwaysUse
                                                .failureUrl("/auth/login?error=true")
                                                .permitAll())
                                .logout(logout -> logout
                                                .logoutUrl("/logout")
                                                .logoutSuccessUrl("/auth/login?logout=true")
                                                .permitAll());
                return http.build();
        }

        @Bean
        public PasswordEncoder passwordEncoder() {
                // CHỈ DÙNG KHI TEST LOCAL: so sánh plain-text
                return new PasswordEncoder() {
                        @Override
                        public String encode(CharSequence rawPassword) {
                                return rawPassword == null ? null : rawPassword.toString();
                        }

                        @Override
                        public boolean matches(CharSequence rawPassword, String encodedPassword) {
                                if (rawPassword == null && encodedPassword == null)
                                        return true;
                                if (rawPassword == null || encodedPassword == null)
                                        return false;
                                return encodedPassword.equals(rawPassword.toString());
                        }
                };
        }
}
