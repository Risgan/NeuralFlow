package com.nauralnet.neuralflow.domain.usecase

import com.nauralnet.neuralflow.domain.model.Task
import com.nauralnet.neuralflow.domain.model.TaskRecurrence
import com.nauralnet.neuralflow.domain.repository.TaskRepository

class CreateTaskUseCase(
    private val repository: TaskRepository
) {

    suspend operator fun invoke(task: Task, recurrence: TaskRecurrence?): Result<Long> {
        return try {
            // Validar que la tarea tenga título
            if (task.title.isBlank()) {
                return Result.failure(Exception("El título no puede estar vacío"))
            }

            // Crear la tarea con su recurrencia
            val taskId = repository.createTask(task, recurrence)

            // TODO: Generar occurrences iniciales (se hará en GenerateOccurrencesUseCase)

            Result.success(taskId)
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
}
