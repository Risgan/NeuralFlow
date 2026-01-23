package com.nauralnet.neuralflow.data.local.dao

import androidx.room.Dao
import androidx.room.Delete
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.Query
import androidx.room.Update
import com.nauralnet.neuralflow.data.local.entity.TaskHistoryEntity
import kotlinx.coroutines.flow.Flow

@Dao
interface TaskHistoryDao {

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insert(history: TaskHistoryEntity): Long

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertAll(histories: List<TaskHistoryEntity>): List<Long>

    @Update
    suspend fun update(history: TaskHistoryEntity)

    @Delete
    suspend fun delete(history: TaskHistoryEntity)

    @Query("SELECT * FROM task_history WHERE id = :historyId")
    suspend fun getHistoryById(historyId: Int): TaskHistoryEntity?

    @Query("SELECT * FROM task_history WHERE occurrence_id = :occurrenceId ORDER BY action_date DESC")
    fun getHistoryByOccurrenceId(occurrenceId: Int): Flow<List<TaskHistoryEntity>>

    @Query("SELECT * FROM task_history ORDER BY action_date DESC")
    fun getAllHistory(): Flow<List<TaskHistoryEntity>>

    @Query("SELECT * FROM task_history ORDER BY action_date DESC LIMIT :limit")
    fun getRecentHistory(limit: Int): Flow<List<TaskHistoryEntity>>

    @Query("SELECT * FROM task_history WHERE `action` = :action ORDER BY action_date DESC")
    fun getHistoryByAction(action: String): Flow<List<TaskHistoryEntity>>

    @Query("SELECT * FROM task_history WHERE action_date BETWEEN :startDate AND :endDate ORDER BY action_date DESC")
    fun getHistoryBetweenDates(startDate: String, endDate: String): Flow<List<TaskHistoryEntity>>

    @Query("DELETE FROM task_history WHERE occurrence_id = :occurrenceId")
    suspend fun deleteByOccurrenceId(occurrenceId: Int)

    @Query("SELECT COUNT(*) FROM task_history WHERE `action` = :action")
    suspend fun getCountByAction(action: String): Int

    @Query("""
        SELECT th.* FROM task_history th
        INNER JOIN task_occurrences oc ON th.occurrence_id = oc.id
        WHERE oc.task_id = :taskId
        ORDER BY th.action_date DESC
    """)
    fun getHistoryByTaskId(taskId: Int): Flow<List<TaskHistoryEntity>>
}
