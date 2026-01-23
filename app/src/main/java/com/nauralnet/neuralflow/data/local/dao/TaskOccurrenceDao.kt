package com.nauralnet.neuralflow.data.local.dao

import androidx.room.Dao
import androidx.room.Delete
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.Query
import androidx.room.Update
import com.nauralnet.neuralflow.data.local.entity.TaskOccurrenceEntity
import kotlinx.coroutines.flow.Flow

@Dao
interface TaskOccurrenceDao {

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insert(occurrence: TaskOccurrenceEntity): Long

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertAll(occurrences: List<TaskOccurrenceEntity>): List<Long>

    @Update
    suspend fun update(occurrence: TaskOccurrenceEntity)

    @Delete
    suspend fun delete(occurrence: TaskOccurrenceEntity)

    @Query("SELECT * FROM task_occurrences WHERE id = :occurrenceId")
    suspend fun getOccurrenceById(occurrenceId: Int): TaskOccurrenceEntity?

    @Query("SELECT * FROM task_occurrences WHERE id = :occurrenceId")
    fun getOccurrenceByIdFlow(occurrenceId: Int): Flow<TaskOccurrenceEntity?>

    @Query("SELECT * FROM task_occurrences WHERE task_id = :taskId ORDER BY date ASC")
    fun getOccurrencesByTaskId(taskId: Int): Flow<List<TaskOccurrenceEntity>>

    @Query("SELECT * FROM task_occurrences WHERE date = :date ORDER BY created_at ASC")
    fun getOccurrencesByDate(date: String): Flow<List<TaskOccurrenceEntity>>

    @Query("SELECT * FROM task_occurrences WHERE date BETWEEN :startDate AND :endDate ORDER BY date ASC")
    fun getOccurrencesBetweenDates(startDate: String, endDate: String): Flow<List<TaskOccurrenceEntity>>

    @Query("SELECT * FROM task_occurrences WHERE status = :status ORDER BY date DESC")
    fun getOccurrencesByStatus(status: String): Flow<List<TaskOccurrenceEntity>>

    @Query("SELECT * FROM task_occurrences WHERE date = :date AND status = :status")
    fun getOccurrencesByDateAndStatus(date: String, status: String): Flow<List<TaskOccurrenceEntity>>

    @Query("SELECT * FROM task_occurrences WHERE task_id = :taskId AND date = :date")
    suspend fun getOccurrenceByTaskAndDate(taskId: Int, date: String): TaskOccurrenceEntity?

    @Query("UPDATE task_occurrences SET status = :status WHERE id = :occurrenceId")
    suspend fun updateStatus(occurrenceId: Int, status: String)

    @Query("UPDATE task_occurrences SET status = :status, completed_at = :completedAt WHERE id = :occurrenceId")
    suspend fun updateStatusWithCompletedAt(occurrenceId: Int, status: String, completedAt: String)

    @Query("UPDATE task_occurrences SET moved_to_date = :movedToDate WHERE id = :occurrenceId")
    suspend fun updateMovedToDate(occurrenceId: Int, movedToDate: String?)

    @Query("DELETE FROM task_occurrences WHERE task_id = :taskId")
    suspend fun deleteByTaskId(taskId: Int)

    @Query("DELETE FROM task_occurrences WHERE task_id = :taskId AND date >= :fromDate")
    suspend fun deleteFutureOccurrences(taskId: Int, fromDate: String)

    @Query("SELECT COUNT(*) FROM task_occurrences WHERE date = :date AND status = 'COMPLETED'")
    suspend fun getCompletedCountByDate(date: String): Int

    @Query("SELECT COUNT(*) FROM task_occurrences WHERE date = :date AND status = 'PENDING'")
    suspend fun getPendingCountByDate(date: String): Int
}
