package com.nauralnet.neuralflow.data.local.entity

import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.ForeignKey
import androidx.room.Index
import androidx.room.PrimaryKey
import java.time.LocalDate
import java.time.LocalDateTime

@Entity(
    tableName = "task_occurrences",
    foreignKeys = [
        ForeignKey(
            entity = TaskEntity::class,
            parentColumns = ["id"],
            childColumns = ["task_id"],
            onDelete = ForeignKey.CASCADE
        )
    ],
    indices = [Index(value = ["task_id"]), Index(value = ["date"])]
)
data class TaskOccurrenceEntity(
    @PrimaryKey(autoGenerate = true)
    val id: Int = 0,

    @ColumnInfo(name = "task_id")
    val taskId: Int,

    @ColumnInfo(name = "date")
    val date: LocalDate,

    @ColumnInfo(name = "status")
    val status: String, // PENDING, COMPLETED, MINIMAL, SKIPPED, MOVED, CANCELLED

    @ColumnInfo(name = "completed_at")
    val completedAt: LocalDateTime? = null,

    @ColumnInfo(name = "moved_to_date")
    val movedToDate: LocalDate? = null,

    @ColumnInfo(name = "created_at")
    val createdAt: LocalDateTime
)
