package com.StudentManagement.repository;

import com.StudentManagement.entity.ScoreHistory;
import com.StudentManagement.entity.Score;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface ScoreHistoryRepository extends JpaRepository<ScoreHistory, Long> {

    /**
     * Lấy lịch sử thay đổi điểm theo Score ID, sắp xếp theo thời gian giảm dần
     */
    @Query("SELECT sh FROM ScoreHistory sh " +
            "LEFT JOIN FETCH sh.changedByUser u " +
            "WHERE sh.score.id = :scoreId " +
            "ORDER BY sh.changedAt DESC")
    List<ScoreHistory> findByScoreIdOrderByChangedAtDesc(@Param("scoreId") Long scoreId);

    /**
     * Lấy lịch sử theo Score entity
     */
    List<ScoreHistory> findByScoreOrderByChangedAtDesc(Score score);

    /**
     * Đếm số lần thay đổi của một điểm
     */
    @Query("SELECT COUNT(sh) FROM ScoreHistory sh WHERE sh.score.id = :scoreId")
    long countByScoreId(@Param("scoreId") Long scoreId);

    /**
     * Lấy bản ghi lịch sử mới nhất của một điểm
     */
    @Query("SELECT sh FROM ScoreHistory sh " +
            "WHERE sh.score.id = :scoreId " +
            "ORDER BY sh.changedAt DESC " +
            "LIMIT 1")
    ScoreHistory findLatestByScoreId(@Param("scoreId") Long scoreId);
}