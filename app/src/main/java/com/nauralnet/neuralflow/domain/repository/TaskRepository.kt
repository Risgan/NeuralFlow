package com.nauralnet.neuralflow.domain.repository

import com.nauralnet.neuralflow.domain.model.Task
import com.nauralnet.neuralflow.domain.model.TaskHistory
import com.nauralnet.neuralflow.domain.model.TaskOccurrence
import com.nauralnet.neuralflow.domain.model.TaskRecurrence
import kotlinx.coroutines.flow.Flow
import java.time.LocalDate
import java.time.LocalDateTime

interface TaskRepository {

    // ==================== TASK ====================

    suspend fun createTask(task: Task, recurrence: TaskRecurrence?): Long

    suspend fun updateTask(task: Task)

    suspend fun deleteTask(taskId: Int)

    suspend fun softDeleteTask(taskId: Int, deleteAt: LocalDateTime)

    suspend fun getTaskById(taskId: Int): Task?

    fun getTaskByIdFlow(taskId: Int): Flow<Task?>

    fun getAllTasks(): Flow<List<Task>>

    fun getActiveTasks(): Flow<List<Task>>

    fun getInactiveTasks(): Flow<List<Task>>

    suspend fun enableTask(taskId: Int)

    suspend fun disableTask(taskId: Int)

    // ==================== RECURRENCE ====================

    suspend fun getRecurrenceByTaskId(taskId: Int): TaskRecurrence?

    fun getRecurrenceByTaskIdFlow(taskId: Int): Flow<TaskRecurrence?>

    suspend fun updateRecurrence(recurrence: TaskRecurrence)

    // ==================== OCCURRENCE ====================

    suspend fun createOccurrence(occurrence: TaskOccurrence): Long

    suspend fun createOccurrences(occurrences: List<TaskOccurrence>)

    suspend fun updateOccurrence(occurrence: TaskOccurrence)

    suspend fun getOccurrenceById(occurrenceId: Int): TaskOccurrence?

    fun getOccurrenceByIdFlow(occurrenceId: Int): Flow<TaskOccurrence?>

    fun getOccurrencesByTaskId(taskId: Int): Flow<List<TaskOccurrence>>

    fun getOccurrencesByDate(date: LocalDate): Flow<List<TaskOccurrence>>

    fun getOccurrencesBetweenDates(startDate: LocalDate, endDate: LocalDate): Flow<List<TaskOccurrence>>

    suspend fun getOccurrenceByTaskAndDate(taskId: Int, date: LocalDate): TaskOccurrence?

    suspend fun completeOccurrence(occurrenceId: Int, completedAt: LocalDateTime)

    suspend fun markOccurrenceAsMinimal(occurrenceId: Int, completedAt: LocalDateTime)

    suspend fun skipOccurrence(occurrenceId: Int)

    suspend fun moveOccurrence(occurrenceId: Int, newDate: LocalDate)

    suspend fun cancelOccurrence(occurrenceId: Int)

    suspend fun deleteFutureOccurrences(taskId: Int, fromDate: LocalDate)

    suspend fun getPendingCountByDate(date: LocalDate): Int

    suspend fun getCompletedCountByDate(date: LocalDate): Int

    // ==================== HISTORY ====================

    suspend fun addHistoryEntry(history: TaskHistory): Long

    fun getHistoryByOccurrenceId(occurrenceId: Int): Flow<List<TaskHistory>>

    fun getHistoryByTaskId(taskId: Int): Flow<List<TaskHistory>>

    fun getAllHistory(): Flow<List<TaskHistory>>

    fun getRecentHistory(limit: Int): Flow<List<TaskHistory>>
}
