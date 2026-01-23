package com.nauralnet.neuralflow.domain.model

data class TaskRecurrence(
    val id: Int = 0,
    val taskId: Int,
    val interval: Int = 1,
    val daysOfWeek: List<DayOfWeek> = emptyList(),
    val dayOfMonth: Int? = null,
    val weekOfMonth: Int? = null,
    val weekday: DayOfWeek? = null
)

enum class DayOfWeek {
    MONDAY,
    TUESDAY,
    WEDNESDAY,
    THURSDAY,
    FRIDAY,
    SATURDAY,
    SUNDAY;

    companion object {
        fun fromString(value: String): DayOfWeek {
            return valueOf(value.uppercase())
        }

        fun fromList(csv: String): List<DayOfWeek> {
            return csv.split(",")
                .map { it.trim() }
                .filter { it.isNotEmpty() }
                .map { fromString(it) }
        }
    }
}

