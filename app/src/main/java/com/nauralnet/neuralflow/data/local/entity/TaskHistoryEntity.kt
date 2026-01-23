package com.nauralnet.neuralflow.data.local.entity

import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.ForeignKey
import androidx.room.Index
import androidx.room.PrimaryKey
import java.time.LocalDateTime

@Entity(
    tableName = "task_history",
    foreignKeys = [
        ForeignKey(
            entity = TaskOccurrenceEntity::class,
            parentColumns = ["id"],
            childColumns = ["occurrence_id"],
            onDelete = ForeignKey.CASCADE
        )
    ],
    indices = [Index(value = ["occurrence_id"])]
)
data class TaskHistoryEntity(
    @PrimaryKey(autoGenerate = true)
    val id: Int = 0,

    @ColumnInfo(name = "occurrence_id")
    val occurrenceId: Int,

    @ColumnInfo(name = "action")
    val action: String, // CREATED, COMPLETED, MINIMAL, SKIPPED, MOVED, DISABLED, ENABLED, DELETED

    @ColumnInfo(name = "action_date")
    val actionDate: LocalDateTime
)
