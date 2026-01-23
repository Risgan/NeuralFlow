package com.nauralnet.neuralflow.data.local.mapper

import com.nauralnet.neuralflow.data.local.entity.TaskEntity
import com.nauralnet.neuralflow.domain.model.Priority
import com.nauralnet.neuralflow.domain.model.RecurrenceType
import com.nauralnet.neuralflow.domain.model.Task

fun TaskEntity.toDomain(): Task {
    return Task(
        id = id,
        title = title,
        priority = Priority.valueOf(priority),
        recurrenceType = RecurrenceType.valueOf(recurrenceType),
        hasTime = hasTime,
        time = time,
        isActive = isActive,
        createdAt = createdAt,
        isDelete = isDelete,
        deleteAt = deleteAt
    )
}

fun Task.toEntity(): TaskEntity {
    return TaskEntity(
        id = id,
        title = title,
        priority = priority.name,
        recurrenceType = recurrenceType.name,
        hasTime = hasTime,
        time = time,
        isActive = isActive,
        createdAt = createdAt,
        isDelete = isDelete,
        deleteAt = deleteAt
    )
}
