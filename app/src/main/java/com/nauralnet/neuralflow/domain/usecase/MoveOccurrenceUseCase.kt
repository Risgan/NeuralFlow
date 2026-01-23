package com.nauralnet.neuralflow.domain.usecase

import com.nauralnet.neuralflow.domain.model.HistoryAction
import com.nauralnet.neuralflow.domain.model.OccurrenceStatus
import com.nauralnet.neuralflow.domain.model.TaskHistory
import com.nauralnet.neuralflow.domain.model.TaskOccurrence
import com.nauralnet.neuralflow.domain.repository.TaskRepository
import java.time.LocalDate
import java.time.LocalDateTime

class MoveOccurrenceUseCase(
    private val repository: TaskRepository
) {

    suspend operator fun invoke(occurrenceId: Int, newDate: LocalDate): Result<Unit> {
        return try {
            // Obtener la occurrence actual
            val occurrence = repository.getOccurrenceById(occurrenceId)
                ?: return Result.failure(Exception("Occurrence no encontrada"))

            // Validar que no se mueva al mismo día
            if (occurrence.date == newDate) {
                return Result.failure(Exception("No se puede mover a la misma fecha"))
            }

            // Marcar la actual como MOVED
            repository.moveOccurrence(occurrenceId, newDate)

            // Crear nueva occurrence en la nueva fecha
            val newOccurrence = TaskOccurrence(
                taskId = occurrence.taskId,
                date = newDate,
                status = OccurrenceStatus.PENDING,
                createdAt = LocalDateTime.now()
            )
            repository.createOccurrence(newOccurrence)

            // Registrar en el historial
            repository.addHistoryEntry(
                TaskHistory(
                    occurrenceId = occurrenceId,
                    action = HistoryAction.MOVED,
                    actionDate = LocalDateTime.now()
                )
            )

            Result.success(Unit)
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
}
