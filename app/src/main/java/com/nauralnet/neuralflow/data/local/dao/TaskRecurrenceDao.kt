package com.nauralnet.neuralflow.data.local.dao

import androidx.room.Dao
import androidx.room.Delete
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.Query
import androidx.room.Update
import com.nauralnet.neuralflow.data.local.entity.TaskRecurrenceEntity
import kotlinx.coroutines.flow.Flow

@Dao
interface TaskRecurrenceDao {

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insert(recurrence: TaskRecurrenceEntity): Long

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertAll(recurrences: List<TaskRecurrenceEntity>): List<Long>

    @Update
    suspend fun update(recurrence: TaskRecurrenceEntity)

    @Delete
    suspend fun delete(recurrence: TaskRecurrenceEntity)

    @Query("SELECT * FROM task_recurrences WHERE id = :recurrenceId")
    suspend fun getRecurrenceById(recurrenceId: Int): TaskRecurrenceEntity?

    @Query("SELECT * FROM task_recurrences WHERE task_id = :taskId")
    suspend fun getRecurrenceByTaskId(taskId: Int): TaskRecurrenceEntity?

    @Query("SELECT * FROM task_recurrences WHERE task_id = :taskId")
    fun getRecurrenceByTaskIdFlow(taskId: Int): Flow<TaskRecurrenceEntity?>

    @Query("SELECT * FROM task_recurrences")
    fun getAllRecurrences(): Flow<List<TaskRecurrenceEntity>>

    @Query("DELETE FROM task_recurrences WHERE task_id = :taskId")
    suspend fun deleteByTaskId(taskId: Int)
}
