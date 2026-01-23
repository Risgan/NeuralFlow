package com.nauralnet.neuralflow.domain.model

import java.time.LocalDate
import java.time.LocalDateTime

data class TaskOccurrence(
    val id: Int = 0,
    val taskId: Int,
    val date: LocalDate,
    val status: OccurrenceStatus,
    val completedAt: LocalDateTime? = null,
    val movedToDate: LocalDate? = null,
    val createdAt: LocalDateTime
)

enum class OccurrenceStatus {
    PENDING,
    COMPLETED,
    MINIMAL,
    SKIPPED,
    MOVED,
    CANCELLED;

    companion object {
        fun fromString(value: String): OccurrenceStatus {
            return valueOf(value.uppercase())
        }
    }
}

