package com.nauralnet.neuralflow.data.repository

import com.nauralnet.neuralflow.data.local.dao.TaskDao
import com.nauralnet.neuralflow.data.local.dao.TaskHistoryDao
import com.nauralnet.neuralflow.data.local.dao.TaskOccurrenceDao
import com.nauralnet.neuralflow.data.local.dao.TaskRecurrenceDao
import com.nauralnet.neuralflow.data.local.mapper.toDomain
import com.nauralnet.neuralflow.data.local.mapper.toEntity
import com.nauralnet.neuralflow.domain.model.OccurrenceStatus
import com.nauralnet.neuralflow.domain.model.Task
import com.nauralnet.neuralflow.domain.model.TaskHistory
import com.nauralnet.neuralflow.domain.model.TaskOccurrence
import com.nauralnet.neuralflow.domain.model.TaskRecurrence
import com.nauralnet.neuralflow.domain.repository.TaskRepository
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map
import java.time.LocalDate
import java.time.LocalDateTime

class TaskRepositoryImpl(
    private val taskDao: TaskDao,
    private val taskRecurrenceDao: TaskRecurrenceDao,
    private val taskOccurrenceDao: TaskOccurrenceDao,
    private val taskHistoryDao: TaskHistoryDao
) : TaskRepository {

    // ==================== TASK ====================

    override suspend fun createTask(task: Task, recurrence: TaskRecurrence?): Long {
        val taskId = taskDao.insert(task.toEntity())

        // Si tiene recurrencia, guardarla
        recurrence?.let {
            val recurrenceWithTaskId = it.copy(taskId = taskId.toInt())
            taskRecurrenceDao.insert(recurrenceWithTaskId.toEntity())
        }

        return taskId
    }

    override suspend fun updateTask(task: Task) {
        taskDao.update(task.toEntity())
    }

    override suspend fun deleteTask(taskId: Int) {
        taskDao.hardDeleteTask(taskId)
    }

    override suspend fun softDeleteTask(taskId: Int, deleteAt: LocalDateTime) {
        taskDao.softDeleteTask(taskId, deleteAt.toString())
    }

    override suspend fun getTaskById(taskId: Int): Task? {
        return taskDao.getTaskById(taskId)?.toDomain()
    }

    override fun getTaskByIdFlow(taskId: Int): Flow<Task?> {
        return taskDao.getTaskByIdFlow(taskId).map { it?.toDomain() }
    }

    override fun getAllTasks(): Flow<List<Task>> {
        return taskDao.getAllTasks().map { list -> list.map { it.toDomain() } }
    }

    override fun getActiveTasks(): Flow<List<Task>> {
        return taskDao.getActiveTasks().map { list -> list.map { it.toDomain() } }
    }

    override fun getInactiveTasks(): Flow<List<Task>> {
        return taskDao.getInactiveTasks().map { list -> list.map { it.toDomain() } }
    }

    override suspend fun enableTask(taskId: Int) {
        taskDao.updateTaskActiveStatus(taskId, true)
    }

    override suspend fun disableTask(taskId: Int) {
        taskDao.updateTaskActiveStatus(taskId, false)
    }

    // ==================== RECURRENCE ====================

    override suspend fun getRecurrenceByTaskId(taskId: Int): TaskRecurrence? {
        return taskRecurrenceDao.getRecurrenceByTaskId(taskId)?.toDomain()
    }

    override fun getRecurrenceByTaskIdFlow(taskId: Int): Flow<TaskRecurrence?> {
        return taskRecurrenceDao.getRecurrenceByTaskIdFlow(taskId).map { it?.toDomain() }
    }

    override suspend fun updateRecurrence(recurrence: TaskRecurrence) {
        taskRecurrenceDao.update(recurrence.toEntity())
    }

    // ==================== OCCURRENCE ====================

    override suspend fun createOccurrence(occurrence: TaskOccurrence): Long {
        return taskOccurrenceDao.insert(occurrence.toEntity())
    }

    override suspend fun createOccurrences(occurrences: List<TaskOccurrence>) {
        taskOccurrenceDao.insertAll(occurrences.map { it.toEntity() })
    }

    override suspend fun updateOccurrence(occurrence: TaskOccurrence) {
        taskOccurrenceDao.update(occurrence.toEntity())
    }

    override suspend fun getOccurrenceById(occurrenceId: Int): TaskOccurrence? {
        return taskOccurrenceDao.getOccurrenceById(occurrenceId)?.toDomain()
    }

    override fun getOccurrenceByIdFlow(occurrenceId: Int): Flow<TaskOccurrence?> {
        return taskOccurrenceDao.getOccurrenceByIdFlow(occurrenceId).map { it?.toDomain() }
    }

    override fun getOccurrencesByTaskId(taskId: Int): Flow<List<TaskOccurrence>> {
        return taskOccurrenceDao.getOccurrencesByTaskId(taskId)
            .map { list -> list.map { it.toDomain() } }
    }

    override fun getOccurrencesByDate(date: LocalDate): Flow<List<TaskOccurrence>> {
        return taskOccurrenceDao.getOccurrencesByDate(date.toString())
            .map { list -> list.map { it.toDomain() } }
    }

    override fun getOccurrencesBetweenDates(
        startDate: LocalDate,
        endDate: LocalDate
    ): Flow<List<TaskOccurrence>> {
        return taskOccurrenceDao.getOccurrencesBetweenDates(
            startDate.toString(),
            endDate.toString()
        ).map { list -> list.map { it.toDomain() } }
    }

    override suspend fun getOccurrenceByTaskAndDate(
        taskId: Int,
        date: LocalDate
    ): TaskOccurrence? {
        return taskOccurrenceDao.getOccurrenceByTaskAndDate(taskId, date.toString())?.toDomain()
    }

    override suspend fun completeOccurrence(occurrenceId: Int, completedAt: LocalDateTime) {
        taskOccurrenceDao.updateStatusWithCompletedAt(
            occurrenceId,
            OccurrenceStatus.COMPLETED.name,
            completedAt.toString()
        )
    }

    override suspend fun markOccurrenceAsMinimal(occurrenceId: Int, completedAt: LocalDateTime) {
        taskOccurrenceDao.updateStatusWithCompletedAt(
            occurrenceId,
            OccurrenceStatus.MINIMAL.name,
            completedAt.toString()
        )
    }

    override suspend fun skipOccurrence(occurrenceId: Int) {
        taskOccurrenceDao.updateStatus(occurrenceId, OccurrenceStatus.SKIPPED.name)
    }

    override suspend fun moveOccurrence(occurrenceId: Int, newDate: LocalDate) {
        taskOccurrenceDao.updateStatus(occurrenceId, OccurrenceStatus.MOVED.name)
        taskOccurrenceDao.updateMovedToDate(occurrenceId, newDate.toString())
    }

    override suspend fun cancelOccurrence(occurrenceId: Int) {
        taskOccurrenceDao.updateStatus(occurrenceId, OccurrenceStatus.CANCELLED.name)
    }

    override suspend fun deleteFutureOccurrences(taskId: Int, fromDate: LocalDate) {
        taskOccurrenceDao.deleteFutureOccurrences(taskId, fromDate.toString())
    }

    override suspend fun getPendingCountByDate(date: LocalDate): Int {
        return taskOccurrenceDao.getPendingCountByDate(date.toString())
    }

    override suspend fun getCompletedCountByDate(date: LocalDate): Int {
        return taskOccurrenceDao.getCompletedCountByDate(date.toString())
    }

    // ==================== HISTORY ====================

    override suspend fun addHistoryEntry(history: TaskHistory): Long {
        return taskHistoryDao.insert(history.toEntity())
    }

    override fun getHistoryByOccurrenceId(occurrenceId: Int): Flow<List<TaskHistory>> {
        return taskHistoryDao.getHistoryByOccurrenceId(occurrenceId)
            .map { list -> list.map { it.toDomain() } }
    }

    override fun getHistoryByTaskId(taskId: Int): Flow<List<TaskHistory>> {
        return taskHistoryDao.getHistoryByTaskId(taskId)
            .map { list -> list.map { it.toDomain() } }
    }

    override fun getAllHistory(): Flow<List<TaskHistory>> {
        return taskHistoryDao.getAllHistory()
            .map { list -> list.map { it.toDomain() } }
    }

    override fun getRecentHistory(limit: Int): Flow<List<TaskHistory>> {
        return taskHistoryDao.getRecentHistory(limit)
            .map { list -> list.map { it.toDomain() } }
    }
}
