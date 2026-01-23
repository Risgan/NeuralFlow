package com.nauralnet.neuralflow.data.local.database

import androidx.room.Database
import androidx.room.RoomDatabase
import androidx.room.TypeConverters
import com.nauralnet.neuralflow.data.local.dao.TaskDao
import com.nauralnet.neuralflow.data.local.dao.TaskHistoryDao
import com.nauralnet.neuralflow.data.local.dao.TaskOccurrenceDao
import com.nauralnet.neuralflow.data.local.dao.TaskRecurrenceDao
import com.nauralnet.neuralflow.data.local.entity.TaskEntity
import com.nauralnet.neuralflow.data.local.entity.TaskHistoryEntity
import com.nauralnet.neuralflow.data.local.entity.TaskOccurrenceEntity
import com.nauralnet.neuralflow.data.local.entity.TaskRecurrenceEntity

@Database(
    entities = [
        TaskEntity::class,
        TaskRecurrenceEntity::class,
        TaskOccurrenceEntity::class,
        TaskHistoryEntity::class
    ],
    version = 1,
    exportSchema = false
)
@TypeConverters(Converters::class)
abstract class NeuralFlowDatabase : RoomDatabase() {
    abstract fun taskDao(): TaskDao
    abstract fun taskRecurrenceDao(): TaskRecurrenceDao
    abstract fun taskOccurrenceDao(): TaskOccurrenceDao
    abstract fun taskHistoryDao(): TaskHistoryDao
}
