package com.nauralnet.neuralflow.domain.model

import java.time.LocalDateTime

data class TaskHistory(
    val id: Int = 0,
    val occurrenceId: Int,
    val action: HistoryAction,
    val actionDate: LocalDateTime
)

enum class HistoryAction {
    CREATED,
    COMPLETED,
    MINIMAL,
    SKIPPED,
    MOVED,
    DISABLED,
    ENABLED,
    DELETED;

    companion object {
        fun fromString(value: String): HistoryAction {
            return valueOf(value.uppercase())
        }
    }
}

