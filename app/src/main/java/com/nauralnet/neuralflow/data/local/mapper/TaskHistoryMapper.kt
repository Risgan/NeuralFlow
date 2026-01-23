package com.nauralnet.neuralflow.data.local.mapper

import com.nauralnet.neuralflow.data.local.entity.TaskHistoryEntity
import com.nauralnet.neuralflow.domain.model.HistoryAction
import com.nauralnet.neuralflow.domain.model.TaskHistory

fun TaskHistoryEntity.toDomain(): TaskHistory {
    return TaskHistory(
        id = id,
        occurrenceId = occurrenceId,
        action = HistoryAction.fromString(action),
        actionDate = actionDate
    )
}

fun TaskHistory.toEntity(): TaskHistoryEntity {
    return TaskHistoryEntity(
        id = id,
        occurrenceId = occurrenceId,
        action = action.name,
        actionDate = actionDate
    )
}
