package com.nauralnet.neuralflow.domain.model

import java.time.LocalDateTime
import java.time.LocalTime

data class Task(
    val id: Int = 0,
    val title: String,
    val priority: Priority,
    val recurrenceType: RecurrenceType,
    val hasTime: Boolean,
    val time: LocalTime? = null,
    val isActive: Boolean = true,
    val createdAt: LocalDateTime,
    val isDelete: Boolean = false,
    val deleteAt: LocalDateTime? = null
)

enum class Priority {
    LOW,
    MEDIUM,
    HIGH
}

enum class RecurrenceType {
    ONCE,
    DAILY,
    WEEKLY,
    MONTHLY_FIXED,
    MONTHLY_PATTERN
}

