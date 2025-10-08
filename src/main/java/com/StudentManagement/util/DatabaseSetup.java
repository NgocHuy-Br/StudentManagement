package com.StudentManagement.util;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

@Component
public class DatabaseSetup implements CommandLineRunner {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Override
    public void run(String... args) throws Exception {
        if (args.length > 0 && "setup-test-data".equals(args[0])) {
            setupTestData();
        }
    }

    private void setupTestData() {
        try {
            System.out.println("=== Setting up test data for teacher assignments ===");

            // Read and execute the SQL script
            String scriptPath = "add-teacher-assignment.sql";
            String sql = readSqlFile(scriptPath);

            // Split by semicolon and execute each statement
            String[] statements = sql.split(";");
            for (String statement : statements) {
                String trimmed = statement.trim();
                if (!trimmed.isEmpty() && !trimmed.startsWith("--")) {
                    try {
                        jdbcTemplate.execute(trimmed);
                        System.out.println("Executed: " + trimmed.substring(0, Math.min(50, trimmed.length())) + "...");
                    } catch (Exception e) {
                        System.err.println("Error executing: " + trimmed);
                        System.err.println("Error: " + e.getMessage());
                    }
                }
            }

            // Check results
            checkTeacherAssignments();

        } catch (Exception e) {
            System.err.println("Error setting up test data: " + e.getMessage());
        }
    }

    private String readSqlFile(String filename) throws IOException {
        StringBuilder content = new StringBuilder();
        try (BufferedReader br = new BufferedReader(new FileReader(filename))) {
            String line;
            while ((line = br.readLine()) != null) {
                content.append(line).append("\n");
            }
        }
        return content.toString();
    }

    private void checkTeacherAssignments() {
        System.out.println("\n=== Checking teacher assignments ===");

        // Check teacher 18 assignments
        var assignments = jdbcTemplate.queryForList(
                "SELECT ct.id, ct.classroom_id, c.class_code, c.class_name, ct.start_date " +
                        "FROM classroom_teachers ct " +
                        "JOIN classrooms c ON ct.classroom_id = c.id " +
                        "WHERE ct.teacher_id = 18 AND ct.end_date IS NULL");

        System.out.println("Teacher 18 assignments: " + assignments.size());
        for (var assignment : assignments) {
            System.out.println("- Class: " + assignment.get("class_code") + " (" + assignment.get("class_name") + ")");
        }

        // Check students in classes
        var studentCounts = jdbcTemplate.queryForList(
                "SELECT c.class_code, COUNT(s.id) as student_count " +
                        "FROM classrooms c " +
                        "LEFT JOIN students s ON c.id = s.classroom_id " +
                        "WHERE c.class_code IN ('D21CQCN01-B', 'D21CQCN02-B') " +
                        "GROUP BY c.id, c.class_code");

        System.out.println("\nStudent counts:");
        for (var count : studentCounts) {
            System.out.println("- " + count.get("class_code") + ": " + count.get("student_count") + " students");
        }
    }
}