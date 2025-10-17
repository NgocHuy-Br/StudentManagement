package com.StudentManagement.service;

import com.StudentManagement.entity.Score;
import com.StudentManagement.entity.Student;
import com.StudentManagement.entity.Subject;
import com.StudentManagement.entity.Classroom;
import com.itextpdf.kernel.colors.ColorConstants;
import com.itextpdf.kernel.font.PdfFont;
import com.itextpdf.kernel.font.PdfFontFactory;
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.element.Cell;
import com.itextpdf.layout.element.Paragraph;
import com.itextpdf.layout.element.Table;
import com.itextpdf.layout.properties.TextAlignment;
import com.itextpdf.layout.properties.UnitValue;
import org.springframework.stereotype.Service;

import java.io.ByteArrayOutputStream;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class PdfService {

    public byte[] generateScoresPdf(List<Score> scores, Long classroomId, Long subjectId,
            String classroomName, String subjectName) {
        try {
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            PdfWriter writer = new PdfWriter(baos);
            PdfDocument pdf = new PdfDocument(writer);
            Document document = new Document(pdf);

            // Sử dụng font hỗ trợ tiếng Việt
            PdfFont font = PdfFontFactory.createFont("Helvetica", "UTF-8");
            document.setFont(font);

            // Tiêu đề
            Paragraph title = new Paragraph("BẢNG ĐIỂM SINH VIÊN")
                    .setFontSize(18)
                    .setBold()
                    .setTextAlignment(TextAlignment.CENTER);
            document.add(title);

            // Thông tin lớp và môn học
            if (classroomName != null) {
                document.add(new Paragraph("Lớp: " + classroomName).setFontSize(12));
            }
            if (subjectName != null) {
                document.add(new Paragraph("Môn học: " + subjectName).setFontSize(12));
            }

            // Thời gian in
            document.add(new Paragraph("Thời gian in: " +
                    LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss")))
                    .setFontSize(10)
                    .setMarginBottom(20));

            if (scores.isEmpty()) {
                document.add(new Paragraph("Không có dữ liệu điểm để hiển thị.").setFontSize(12));
            } else {
                // Tạo bảng
                Table table = new Table(UnitValue.createPercentArray(new float[] { 1, 3, 2, 2, 1, 1, 1, 1 }))
                        .setWidth(UnitValue.createPercentValue(100));

                // Header
                table.addHeaderCell(new Cell().add(new Paragraph("STT").setBold())
                        .setBackgroundColor(ColorConstants.LIGHT_GRAY));
                table.addHeaderCell(new Cell().add(new Paragraph("Họ tên").setBold())
                        .setBackgroundColor(ColorConstants.LIGHT_GRAY));
                table.addHeaderCell(new Cell().add(new Paragraph("MSSV").setBold())
                        .setBackgroundColor(ColorConstants.LIGHT_GRAY));
                table.addHeaderCell(new Cell().add(new Paragraph("Môn học").setBold())
                        .setBackgroundColor(ColorConstants.LIGHT_GRAY));
                table.addHeaderCell(new Cell().add(new Paragraph("Điểm QT").setBold())
                        .setBackgroundColor(ColorConstants.LIGHT_GRAY));
                table.addHeaderCell(new Cell().add(new Paragraph("Điểm GK").setBold())
                        .setBackgroundColor(ColorConstants.LIGHT_GRAY));
                table.addHeaderCell(new Cell().add(new Paragraph("Điểm CK").setBold())
                        .setBackgroundColor(ColorConstants.LIGHT_GRAY));
                table.addHeaderCell(new Cell().add(new Paragraph("Điểm TB").setBold())
                        .setBackgroundColor(ColorConstants.LIGHT_GRAY));

                // Dữ liệu
                int index = 1;
                for (Score score : scores) {
                    Student student = score.getStudent();
                    Subject subject = score.getSubject();

                    table.addCell(new Cell().add(new Paragraph(String.valueOf(index++))));
                    table.addCell(new Cell().add(new Paragraph(
                            student.getUser().getFname() + " " + student.getUser().getLname())));
                    table.addCell(new Cell().add(new Paragraph(student.getUser().getUsername())));
                    table.addCell(new Cell().add(new Paragraph(subject.getSubjectName())));
                    table.addCell(new Cell().add(new Paragraph(
                            score.getAttendanceScore() != null ? String.valueOf(score.getAttendanceScore()) : "")));
                    table.addCell(new Cell().add(new Paragraph(
                            score.getMidtermScore() != null ? String.valueOf(score.getMidtermScore()) : "")));
                    table.addCell(new Cell().add(new Paragraph(
                            score.getFinalScore() != null ? String.valueOf(score.getFinalScore()) : "")));
                    table.addCell(new Cell().add(new Paragraph(
                            score.getAvgScore() != null ? String.valueOf(score.getAvgScore()) : "")));
                }

                document.add(table);

                // Thống kê
                document.add(new Paragraph("\nTHỐNG KÊ:")
                        .setBold()
                        .setMarginTop(20));

                document.add(new Paragraph("Tổng số sinh viên: " + scores.size()));

                long passCount = scores.stream()
                        .filter(s -> s.getAvgScore() != null && s.getAvgScore() >= 5.0)
                        .count();
                long failCount = scores.size() - passCount;

                document.add(new Paragraph("Số sinh viên đạt (≥5.0): " + passCount));
                document.add(new Paragraph("Số sinh viên không đạt (<5.0): " + failCount));

                if (scores.size() > 0) {
                    double passRate = (double) passCount / scores.size() * 100;
                    document.add(new Paragraph("Tỷ lệ đạt: " + String.format("%.1f%%", passRate)));
                }
            }

            document.close();
            return baos.toByteArray();

        } catch (Exception e) {
            throw new RuntimeException("Lỗi khi tạo file PDF: " + e.getMessage(), e);
        }
    }
}