package com.nauralnet.neuralflow.domain.usecase

import com.nauralnet.neuralflow.domain.repository.TaskRepository

class EnableTaskUseCase(
    private val repository: TaskRepository
) {

    suspend operator fun invoke(taskId: Int): Result<Unit> {
        return try {
            // Habilitar la tarea
            repository.enableTask(taskId)

            // TODO: Regenerar occurrences futuras desde hoy
            // Esto se hará en GenerateOccurrencesUseCase

            // TODO: Registrar en el historial como ENABLED

            Result.success(Unit)
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
}
