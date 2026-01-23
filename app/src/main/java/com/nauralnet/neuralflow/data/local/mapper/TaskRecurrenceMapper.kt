package com.nauralnet.neuralflow.data.local.mapper

import com.nauralnet.neuralflow.data.local.entity.TaskRecurrenceEntity
import com.nauralnet.neuralflow.domain.model.DayOfWeek
import com.nauralnet.neuralflow.domain.model.TaskRecurrence

fun TaskRecurrenceEntity.toDomain(): TaskRecurrence {
    return TaskRecurrence(
        id = id,
        taskId = taskId,
        interval = interval,
        daysOfWeek = daysOfWeek?.let { DayOfWeek.fromList(it) } ?: emptyList(),
        dayOfMonth = dayOfMonth,
        weekOfMonth = weekOfMonth,
        weekday = weekday?.let { DayOfWeek.fromString(it) }
    )
}

fun TaskRecurrence.toEntity(): TaskRecurrenceEntity {
    return TaskRecurrenceEntity(
        id = id,
        taskId = taskId,
        interval = interval,
        daysOfWeek = daysOfWeek.joinToString(",") { it.name },
        dayOfMonth = dayOfMonth,
        weekOfMonth = weekOfMonth,
        weekday = weekday?.name
    )
}
