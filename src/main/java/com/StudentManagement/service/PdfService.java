package com.StudentManagement.service;

import com.StudentManagement.entity.Score;
import com.StudentManagement.entity.Student;
import com.StudentManagement.entity.Subject;
import com.StudentManagement.entity.Classroom;
import com.StudentManagement.entity.User;
import com.itextpdf.kernel.colors.ColorConstants;
import com.itextpdf.kernel.font.PdfFont;
import com.itextpdf.kernel.font.PdfFontFactory;
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.kernel.pdf.WriterProperties;
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

        // Constants cho các chuỗi tiếng Việt để tránh encoding issues
        private static final String SCHOOL_NAME = "HỌC VIỆN CÔNG NGHỆ BƯU CHÍNH VIỄN THÔNG";
        private static final String REPORT_TITLE = "BẢNG ĐIỂM SINH VIÊN";
        private static final String CLASS_LABEL = "Lớp: ";
        private static final String SUBJECT_LABEL = "Môn học: ";
        private static final String EXPORTED_BY_LABEL = "Người xuất: ";
        private static final String PRINT_TIME_LABEL = "Thời gian in: ";
        private static final String NO_DATA_MESSAGE = "Không có dữ liệu điểm để hiển thị.";
        private static final String CREATOR_LABEL = "NGƯỜI LẬP BẢNG";
        private static final String DEAN_LABEL = "TRƯỞNG KHOA";
        private static final String PASSED_RESULT = "Đạt";
        private static final String FAILED_RESULT = "Không đạt";

        public byte[] generateScoresPdf(List<Score> scores, Long classroomId, Long subjectId,
                        String classroomName, String subjectName) {
                return generateScoresPdf(scores, classroomId, subjectId, classroomName, subjectName, null, null);
        }

        public byte[] generateScoresPdf(List<Score> scores, Long classroomId, Long subjectId,
                        String classroomName, String subjectName, String exportedBy, String searchCriteria) {
                try {
                        ByteArrayOutputStream baos = new ByteArrayOutputStream();
                        // Tạo PdfWriter với UTF-8 encoding
                        PdfWriter writer = new PdfWriter(baos);
                        PdfDocument pdf = new PdfDocument(writer);
                        Document document = new Document(pdf);

                        // Sử dụng font hỗ trợ tiếng Việt - thử nhiều options
                        PdfFont font;
                        try {
                                // Thử sử dụng font từ system trước
                                font = PdfFontFactory.createFont("c:/windows/fonts/arial.ttf", "Identity-H");
                        } catch (Exception e1) {
                                try {
                                        // Thử DejaVu Sans từ font-asian package
                                        font = PdfFontFactory.createFont("DejaVuSans", "Identity-H");
                                } catch (Exception e2) {
                                        try {
                                                // Thử NotoSans từ font-asian package
                                                font = PdfFontFactory.createFont("NotoSans", "Identity-H");
                                        } catch (Exception e3) {
                                                try {
                                                        // Fallback sang font Times-Roman với encoding UTF-8
                                                        font = PdfFontFactory.createFont("Times-Roman", "Identity-H");
                                                } catch (Exception e4) {
                                                        // Cuối cùng sử dụng Helvetica với Unicode encoding
                                                        font = PdfFontFactory.createFont("Helvetica", "Identity-H");
                                                }
                                        }
                                }
                        }
                        document.setFont(font);

                        // Tiêu đề chính
                        Paragraph title = new Paragraph(REPORT_TITLE)
                                        .setFontSize(20)
                                        .setBold()
                                        .setTextAlignment(TextAlignment.CENTER)
                                        .setMarginBottom(10);
                        document.add(title);

                        // Thông tin trường
                        document.add(new Paragraph(SCHOOL_NAME)
                                        .setFontSize(14)
                                        .setBold()
                                        .setTextAlignment(TextAlignment.CENTER)
                                        .setMarginBottom(20));

                        // Thông tin lớp và môn học
                        if (classroomName != null) {
                                document.add(new Paragraph(CLASS_LABEL + classroomName).setFontSize(12).setBold());
                        }
                        if (subjectName != null) {
                                document.add(new Paragraph(SUBJECT_LABEL + subjectName).setFontSize(12).setBold());
                        }

                        // Bỏ dòng bộ lọc theo yêu cầu
                        // if (searchCriteria != null && !searchCriteria.trim().isEmpty()) {
                        // document.add(new Paragraph(FILTER_LABEL +
                        // searchCriteria).setFontSize(10).setItalic());
                        // }

                        // Thông tin người xuất và thời gian
                        if (exportedBy != null) {
                                document.add(new Paragraph(EXPORTED_BY_LABEL + exportedBy).setFontSize(10));
                        }
                        document.add(new Paragraph(PRINT_TIME_LABEL +
                                        LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss")))
                                        .setFontSize(10)
                                        .setMarginBottom(20));

                        if (scores.isEmpty()) {
                                document.add(new Paragraph(NO_DATA_MESSAGE).setFontSize(12));
                        } else {
                                // Tạo bảng với số cột phù hợp
                                Table table = new Table(UnitValue.createPercentArray(
                                                new float[] { 1, 3, 2, 2, 1.5f, 1.5f, 1.5f, 1.5f, 1.5f }))
                                                .setWidth(UnitValue.createPercentValue(100));

                                // Header của bảng
                                table.addHeaderCell(new Cell().add(new Paragraph("STT").setBold())
                                                .setBackgroundColor(ColorConstants.LIGHT_GRAY)
                                                .setTextAlignment(TextAlignment.CENTER));
                                table.addHeaderCell(new Cell().add(new Paragraph("Họ và tên").setBold())
                                                .setBackgroundColor(ColorConstants.LIGHT_GRAY)
                                                .setTextAlignment(TextAlignment.CENTER));
                                table.addHeaderCell(new Cell().add(new Paragraph("MSSV").setBold())
                                                .setBackgroundColor(ColorConstants.LIGHT_GRAY)
                                                .setTextAlignment(TextAlignment.CENTER));
                                table.addHeaderCell(new Cell().add(new Paragraph("Môn học").setBold())
                                                .setBackgroundColor(ColorConstants.LIGHT_GRAY)
                                                .setTextAlignment(TextAlignment.CENTER));
                                table.addHeaderCell(new Cell().add(new Paragraph("Điểm\nchuyên cần").setBold())
                                                .setBackgroundColor(ColorConstants.LIGHT_GRAY)
                                                .setTextAlignment(TextAlignment.CENTER));
                                table.addHeaderCell(new Cell().add(new Paragraph("Điểm\ngiữa kỳ").setBold())
                                                .setBackgroundColor(ColorConstants.LIGHT_GRAY)
                                                .setTextAlignment(TextAlignment.CENTER));
                                table.addHeaderCell(new Cell().add(new Paragraph("Điểm\ncuối kỳ").setBold())
                                                .setBackgroundColor(ColorConstants.LIGHT_GRAY)
                                                .setTextAlignment(TextAlignment.CENTER));
                                table.addHeaderCell(new Cell().add(new Paragraph("Điểm\ntrung bình").setBold())
                                                .setBackgroundColor(ColorConstants.LIGHT_GRAY)
                                                .setTextAlignment(TextAlignment.CENTER));
                                table.addHeaderCell(new Cell().add(new Paragraph("Kết quả").setBold())
                                                .setBackgroundColor(ColorConstants.LIGHT_GRAY)
                                                .setTextAlignment(TextAlignment.CENTER));

                                // Dữ liệu bảng
                                int index = 1;
                                for (Score score : scores) {
                                        Student student = score.getStudent();
                                        Subject subject = score.getSubject();
                                        User user = student.getUser();

                                        // STT
                                        table.addCell(new Cell().add(new Paragraph(String.valueOf(index++)))
                                                        .setTextAlignment(TextAlignment.CENTER));

                                        // Họ và tên (định dạng: Tên + Họ đệm)
                                        String fullName = (user.getLname() + " " + user.getFname()).trim();
                                        table.addCell(new Cell().add(new Paragraph(fullName)));

                                        // MSSV
                                        table.addCell(new Cell().add(new Paragraph(user.getUsername()))
                                                        .setTextAlignment(TextAlignment.CENTER));

                                        // Môn học
                                        table.addCell(new Cell().add(new Paragraph(subject.getSubjectName())));

                                        // Điểm chuyên cần
                                        String attendanceScore = score.getAttendanceScore() != null
                                                        ? String.format("%.1f", score.getAttendanceScore())
                                                        : "--";
                                        table.addCell(new Cell().add(new Paragraph(attendanceScore))
                                                        .setTextAlignment(TextAlignment.CENTER));

                                        // Điểm giữa kỳ
                                        String midtermScore = score.getMidtermScore() != null
                                                        ? String.format("%.1f", score.getMidtermScore())
                                                        : "--";
                                        table.addCell(new Cell().add(new Paragraph(midtermScore))
                                                        .setTextAlignment(TextAlignment.CENTER));

                                        // Điểm cuối kỳ
                                        String finalScore = score.getFinalScore() != null
                                                        ? String.format("%.1f", score.getFinalScore())
                                                        : "--";
                                        table.addCell(new Cell().add(new Paragraph(finalScore))
                                                        .setTextAlignment(TextAlignment.CENTER));

                                        // Điểm trung bình
                                        String avgScore = score.getAvgScore() != null
                                                        ? String.format("%.1f", score.getAvgScore())
                                                        : "--";
                                        table.addCell(new Cell().add(new Paragraph(avgScore))
                                                        .setTextAlignment(TextAlignment.CENTER)
                                                        .setBold());

                                        // Kết quả
                                        String result = "--";
                                        if (score.getAvgScore() != null) {
                                                result = score.getAvgScore() >= 5.0 ? PASSED_RESULT : FAILED_RESULT;
                                        }
                                        table.addCell(new Cell().add(new Paragraph(result))
                                                        .setTextAlignment(TextAlignment.CENTER)
                                                        .setBold());
                                }

                                document.add(table);

                        }

                        // Chữ ký và xác nhận
                        document.add(new Paragraph("\n\n")
                                        .setMarginTop(30));

                        // Tạo bảng chữ ký
                        Table signatureTable = new Table(UnitValue.createPercentArray(new float[] { 1, 1 }))
                                        .setWidth(UnitValue.createPercentValue(100));

                        Cell leftSignature = new Cell().add(new Paragraph(CREATOR_LABEL)
                                        .setBold()
                                        .setTextAlignment(TextAlignment.CENTER))
                                        .setBorder(null);
                        Cell rightSignature = new Cell().add(new Paragraph(DEAN_LABEL)
                                        .setBold()
                                        .setTextAlignment(TextAlignment.CENTER))
                                        .setBorder(null);

                        signatureTable.addCell(leftSignature);
                        signatureTable.addCell(rightSignature);

                        // Thêm khoảng trống cho chữ ký
                        Cell leftSpace = new Cell().add(new Paragraph("\n\n\n")
                                        .setTextAlignment(TextAlignment.CENTER))
                                        .setBorder(null);
                        Cell rightSpace = new Cell().add(new Paragraph("\n\n\n")
                                        .setTextAlignment(TextAlignment.CENTER))
                                        .setBorder(null);

                        signatureTable.addCell(leftSpace);
                        signatureTable.addCell(rightSpace);

                        // Thêm tên người ký
                        if (exportedBy != null) {
                                leftSignature = new Cell().add(new Paragraph("(" + exportedBy + ")")
                                                .setTextAlignment(TextAlignment.CENTER)
                                                .setItalic())
                                                .setBorder(null);
                        } else {
                                leftSignature = new Cell().add(new Paragraph("(..............................)")
                                                .setTextAlignment(TextAlignment.CENTER))
                                                .setBorder(null);
                        }

                        rightSignature = new Cell().add(new Paragraph("(..............................)")
                                        .setTextAlignment(TextAlignment.CENTER))
                                        .setBorder(null);

                        signatureTable.addCell(leftSignature);
                        signatureTable.addCell(rightSignature);

                        document.add(signatureTable);

                        document.close();
                        return baos.toByteArray();

                } catch (Exception e) {
                        throw new RuntimeException("Lỗi khi tạo file PDF: " + e.getMessage(), e);
                }
        }
}