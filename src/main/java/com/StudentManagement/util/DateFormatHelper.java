package com.StudentManagement.util;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

/**
 * Helper class for formatting dates in JSP
 */
public class DateFormatHelper {

    private static final DateTimeFormatter DD_MM_YYYY = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    /**
     * Format LocalDate to dd/MM/yyyy string
     */
    public String format(LocalDate date) {
        if (date == null) {
            return "";
        }
        return date.format(DD_MM_YYYY);
    }

    /**
     * Format LocalDate to dd/MM/yyyy string with null safety
     */
    public String formatSafe(LocalDate date) {
        return date != null ? date.format(DD_MM_YYYY) : "Không xác định";
    }
}