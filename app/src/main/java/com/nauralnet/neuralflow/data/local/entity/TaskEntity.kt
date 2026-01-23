package com.nauralnet.neuralflow.data.local.entity

import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.PrimaryKey
import java.time.LocalDateTime
import java.time.LocalTime

@Entity(tableName = "tasks")
data class TaskEntity(
    @PrimaryKey(autoGenerate = true)
    val id: Int = 0,

    @ColumnInfo(name = "title")
    val title: String,

    @ColumnInfo(name = "priority")
    val priority: String, // LOW, MEDIUM, HIGH

    @ColumnInfo(name = "recurrence_type")
    val recurrenceType: String, // ONCE, DAILY, WEEKLY, MONTHLY_FIXED, MONTHLY_PATTERN

    @ColumnInfo(name = "has_time")
    val hasTime: Boolean,

    @ColumnInfo(name = "time")
    val time: LocalTime? = null,

    @ColumnInfo(name = "is_active")
    val isActive: Boolean = true,

    @ColumnInfo(name = "created_at")
    val createdAt: LocalDateTime,

    @ColumnInfo(name = "is_delete")
    val isDelete: Boolean = false,

    @ColumnInfo(name = "delete_at")
    val deleteAt: LocalDateTime? = null
)
