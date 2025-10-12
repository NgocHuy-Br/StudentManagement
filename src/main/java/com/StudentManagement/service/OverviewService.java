package com.StudentManagement.service;

import com.StudentManagement.dto.FacultyStatDTO;
import com.StudentManagement.dto.MajorStatDTO;
import com.StudentManagement.dto.TotalStatDTO;
import com.StudentManagement.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class OverviewService {

    @Autowired
    private FacultyRepository facultyRepository;

    @Autowired
    private MajorRepository majorRepository;

    @Autowired
    private TeacherRepository teacherRepository;

    @Autowired
    private StudentRepository studentRepository;

    /**
     * Lấy thống kê tổng quát của hệ thống
     */
    public TotalStatDTO getTotalStatistics() {
        Long totalFaculties = facultyRepository.count();
        Long totalMajors = majorRepository.count();
        Long totalTeachers = teacherRepository.count();
        Long totalStudents = studentRepository.count();

        return new TotalStatDTO(totalFaculties, totalMajors, totalTeachers, totalStudents);
    }

    /**
     * Lấy thống kê theo từng khoa
     */
    public List<FacultyStatDTO> getFacultyStatistics() {
        List<FacultyStatDTO> facultyStats = new ArrayList<>();

        facultyRepository.findAll().forEach(faculty -> {
            Long majorCount = majorRepository.countByFaculty(faculty);
            Long teacherCount = teacherRepository.countByFaculty(faculty);
            Long studentCount = studentRepository.countByMajorFaculty(faculty);

            FacultyStatDTO stat = new FacultyStatDTO(
                    faculty.getFacultyCode(),
                    faculty.getName(),
                    majorCount,
                    teacherCount,
                    studentCount);
            facultyStats.add(stat);
        });

        return facultyStats;
    }

    /**
     * Lấy thống kê theo từng ngành
     */
    public List<MajorStatDTO> getMajorStatistics() {
        List<MajorStatDTO> majorStats = new ArrayList<>();

        majorRepository.findAll().forEach(major -> {
            Long studentCount = studentRepository.countByMajor(major);

            MajorStatDTO stat = new MajorStatDTO(
                    major.getMajorCode(),
                    major.getMajorName(),
                    major.getFaculty().getName(),
                    studentCount);
            majorStats.add(stat);
        });

        return majorStats;
    }
}