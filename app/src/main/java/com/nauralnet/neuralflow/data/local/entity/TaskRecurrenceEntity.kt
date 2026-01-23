package com.nauralnet.neuralflow.data.local.entity

import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.ForeignKey
import androidx.room.Index
import androidx.room.PrimaryKey

@Entity(
    tableName = "task_recurrences",
    foreignKeys = [
        ForeignKey(
            entity = TaskEntity::class,
            parentColumns = ["id"],
            childColumns = ["task_id"],
            onDelete = ForeignKey.CASCADE
        )
    ],
    indices = [Index(value = ["task_id"])]
)
data class TaskRecurrenceEntity(
    @PrimaryKey(autoGenerate = true)
    val id: Int = 0,

    @ColumnInfo(name = "task_id")
    val taskId: Int,

    @ColumnInfo(name = "interval")
    val interval: Int = 1,

    @ColumnInfo(name = "days_of_week")
    val daysOfWeek: String? = null, // MON,WED,FRI

    @ColumnInfo(name = "day_of_month")
    val dayOfMonth: Int? = null,

    @ColumnInfo(name = "week_of_month")
    val weekOfMonth: Int? = null,

    @ColumnInfo(name = "weekday")
    val weekday: String? = null // MONDAY, TUESDAY...
)
