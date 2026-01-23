package com.nauralnet.neuralflow.data.local.dao

import androidx.room.Dao
import androidx.room.Delete
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.Query
import androidx.room.Update
import com.nauralnet.neuralflow.data.local.entity.TaskEntity
import kotlinx.coroutines.flow.Flow

@Dao
interface TaskDao {

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insert(task: TaskEntity): Long

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertAll(tasks: List<TaskEntity>): List<Long>

    @Update
    suspend fun update(task: TaskEntity)

    @Delete
    suspend fun delete(task: TaskEntity)

    @Query("SELECT * FROM tasks WHERE id = :taskId")
    suspend fun getTaskById(taskId: Int): TaskEntity?

    @Query("SELECT * FROM tasks WHERE id = :taskId")
    fun getTaskByIdFlow(taskId: Int): Flow<TaskEntity?>

    @Query("SELECT * FROM tasks WHERE is_delete = 0 ORDER BY created_at DESC")
    fun getAllTasks(): Flow<List<TaskEntity>>

    @Query("SELECT * FROM tasks WHERE is_delete = 0 AND is_active = 1 ORDER BY created_at DESC")
    fun getActiveTasks(): Flow<List<TaskEntity>>

    @Query("SELECT * FROM tasks WHERE is_delete = 0 AND is_active = 0 ORDER BY created_at DESC")
    fun getInactiveTasks(): Flow<List<TaskEntity>>

    @Query("SELECT * FROM tasks WHERE is_delete = 1 ORDER BY delete_at DESC")
    fun getDeletedTasks(): Flow<List<TaskEntity>>

    @Query("UPDATE tasks SET is_active = :isActive WHERE id = :taskId")
    suspend fun updateTaskActiveStatus(taskId: Int, isActive: Boolean)

    @Query("UPDATE tasks SET is_delete = 1, delete_at = :deleteAt WHERE id = :taskId")
    suspend fun softDeleteTask(taskId: Int, deleteAt: String)

    @Query("DELETE FROM tasks WHERE id = :taskId")
    suspend fun hardDeleteTask(taskId: Int)

    @Query("SELECT COUNT(*) FROM tasks WHERE is_delete = 0")
    suspend fun getTaskCount(): Int

    @Query("SELECT COUNT(*) FROM tasks WHERE is_delete = 0 AND is_active = 1")
    suspend fun getActiveTaskCount(): Int
}
