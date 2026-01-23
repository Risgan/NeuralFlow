package com.nauralnet.neuralflow.domain.usecase

import com.nauralnet.neuralflow.domain.model.HistoryAction
import com.nauralnet.neuralflow.domain.model.TaskHistory
import com.nauralnet.neuralflow.domain.repository.TaskRepository
import java.time.LocalDateTime

class CompleteOccurrenceUseCase(
    private val repository: TaskRepository
) {

    suspend operator fun invoke(occurrenceId: Int, isMinimal: Boolean = false): Result<Unit> {
        return try {
            val now = LocalDateTime.now()

            // Actualizar el estado de la occurrence
            if (isMinimal) {
                repository.markOccurrenceAsMinimal(occurrenceId, now)
            } else {
                repository.completeOccurrence(occurrenceId, now)
            }

            // Registrar en el historial
            val action = if (isMinimal) HistoryAction.MINIMAL else HistoryAction.COMPLETED
            repository.addHistoryEntry(
                TaskHistory(
                    occurrenceId = occurrenceId,
                    action = action,
                    actionDate = now
                )
            )

            Result.success(Unit)
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
}
