package com.StudentManagement.controller;

import com.StudentManagement.entity.Major;
import com.StudentManagement.entity.Subject;
import com.StudentManagement.repository.MajorRepository;
import com.StudentManagement.repository.SubjectRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
public class DataMigrationController {

    @Autowired
    private SubjectRepository subjectRepository;

    @Autowired
    private MajorRepository majorRepository;

    /**
     * Migrate data from many-to-many relationship to one-to-many
     * Endpoint để chuyển đổi dữ liệu từ mối quan hệ many-to-many sang one-to-many
     * Chỉ chạy một lần sau khi deploy
     */
    @GetMapping("/admin/migrate-subject-major-data")
    @ResponseBody
    @Transactional
    public String migrateSubjectMajorData() {
        try {
            StringBuilder result = new StringBuilder();
            result.append("Starting data migration...\n");

            // Lấy tất cả subjects
            List<Subject> subjects = subjectRepository.findAll();
            result.append("Found ").append(subjects.size()).append(" subjects\n");

            int updatedCount = 0;
            int skippedCount = 0;

            for (Subject subject : subjects) {
                // Kiểm tra nếu subject chưa có major_id (cột mới)
                if (subject.getMajor() == null) {
                    // Lấy danh sách majors của subject từ mối quan hệ cũ (nếu còn tồn tại)
                    // Vì chúng ta đã thay đổi entity, ta sẽ sử dụng native query
                    List<Long> majorIds = getMajorIdsForSubject(subject.getId());

                    if (!majorIds.isEmpty()) {
                        // Chỉ lấy major đầu tiên (vì giờ là one-to-many)
                        Long majorId = majorIds.get(0);
                        Major major = majorRepository.findById(majorId).orElse(null);

                        if (major != null) {
                            subject.setMajor(major);
                            subjectRepository.save(subject);
                            updatedCount++;
                            result.append("Updated subject ").append(subject.getSubjectCode())
                                    .append(" -> major ").append(major.getMajorCode()).append("\n");
                        }
                    } else {
                        skippedCount++;
                        result.append("Skipped subject ").append(subject.getSubjectCode())
                                .append(" (no major found)\n");
                    }
                } else {
                    skippedCount++;
                    result.append("Skipped subject ").append(subject.getSubjectCode())
                            .append(" (already has major: ").append(subject.getMajor().getMajorCode()).append(")\n");
                }
            }

            result.append("\nMigration completed!\n");
            result.append("Updated: ").append(updatedCount).append(" subjects\n");
            result.append("Skipped: ").append(skippedCount).append(" subjects\n");

            return result.toString();

        } catch (Exception e) {
            return "Migration failed: " + e.getMessage();
        }
    }

    /**
     * Helper method to get major IDs for a subject from the old many-to-many table
     */
    private List<Long> getMajorIdsForSubject(Long subjectId) {
        // Sử dụng EntityManager để thực hiện native query
        try {
            return subjectRepository.findMajorIdsBySubjectId(subjectId);
        } catch (Exception e) {
            // Nếu bảng major_subjects không tồn tại nữa, return empty list
            return List.of();
        }
    }
}