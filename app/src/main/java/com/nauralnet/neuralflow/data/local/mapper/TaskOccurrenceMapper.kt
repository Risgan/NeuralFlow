package com.nauralnet.neuralflow.data.local.mapper

import com.nauralnet.neuralflow.data.local.entity.TaskOccurrenceEntity
import com.nauralnet.neuralflow.domain.model.OccurrenceStatus
import com.nauralnet.neuralflow.domain.model.TaskOccurrence

fun TaskOccurrenceEntity.toDomain(): TaskOccurrence {
    return TaskOccurrence(
        id = id,
        taskId = taskId,
        date = date,
        status = OccurrenceStatus.fromString(status),
        completedAt = completedAt,
        movedToDate = movedToDate,
        createdAt = createdAt
    )
}

fun TaskOccurrence.toEntity(): TaskOccurrenceEntity {
    return TaskOccurrenceEntity(
        id = id,
        taskId = taskId,
        date = date,
        status = status.name,
        completedAt = completedAt,
        movedToDate = movedToDate,
        createdAt = createdAt
    )
}
