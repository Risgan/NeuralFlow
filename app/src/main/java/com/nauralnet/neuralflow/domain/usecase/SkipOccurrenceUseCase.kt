package com.nauralnet.neuralflow.domain.usecase

import com.nauralnet.neuralflow.domain.model.HistoryAction
import com.nauralnet.neuralflow.domain.model.TaskHistory
import com.nauralnet.neuralflow.domain.repository.TaskRepository
import java.time.LocalDateTime

class SkipOccurrenceUseCase(
    private val repository: TaskRepository
) {

    suspend operator fun invoke(occurrenceId: Int): Result<Unit> {
        return try {
            // Marcar como omitida
            repository.skipOccurrence(occurrenceId)

            // Registrar en el historial
            repository.addHistoryEntry(
                TaskHistory(
                    occurrenceId = occurrenceId,
                    action = HistoryAction.SKIPPED,
                    actionDate = LocalDateTime.now()
                )
            )

            Result.success(Unit)
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
}
