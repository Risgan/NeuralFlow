package com.nauralnet.neuralflow.domain.usecase

import com.nauralnet.neuralflow.domain.repository.TaskRepository
import java.time.LocalDate

class DisableTaskUseCase(
    private val repository: TaskRepository
) {

    suspend operator fun invoke(taskId: Int): Result<Unit> {
        return try {
            // Deshabilitar la tarea
            repository.disableTask(taskId)

            // Eliminar occurrences futuras (desde mañana)
            val tomorrow = LocalDate.now().plusDays(1)
            repository.deleteFutureOccurrences(taskId, tomorrow)

            // TODO: Registrar en el historial como DISABLED

            Result.success(Unit)
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
}
