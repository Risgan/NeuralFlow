package com.nauralnet.neuralflow.domain.usecase

import com.nauralnet.neuralflow.domain.repository.TaskRepository
import java.time.LocalDateTime

class DeleteTaskUseCase(
    private val repository: TaskRepository
) {

    suspend operator fun invoke(taskId: Int, hardDelete: Boolean = false): Result<Unit> {
        return try {
            if (hardDelete) {
                // Eliminación física (elimina todo en cascada por Room)
                repository.deleteTask(taskId)
            } else {
                // Eliminación lógica (soft delete)
                repository.softDeleteTask(taskId, LocalDateTime.now())
            }

            // TODO: Registrar en el historial como DELETED

            Result.success(Unit)
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
}
