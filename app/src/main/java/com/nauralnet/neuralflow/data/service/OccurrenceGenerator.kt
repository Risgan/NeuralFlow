package com.nauralnet.neuralflow.data.service

import com.nauralnet.neuralflow.domain.model.DayOfWeek
import com.nauralnet.neuralflow.domain.model.OccurrenceStatus
import com.nauralnet.neuralflow.domain.model.RecurrenceType
import com.nauralnet.neuralflow.domain.model.Task
import com.nauralnet.neuralflow.domain.model.TaskOccurrence
import com.nauralnet.neuralflow.domain.model.TaskRecurrence
import java.time.LocalDate
import java.time.LocalDateTime
import java.time.temporal.ChronoUnit

class OccurrenceGenerator {

    /**
     * Genera occurrences para una tarea desde una fecha de inicio
     * @param task La tarea base
     * @param recurrence La configuración de recurrencia (null para ONCE)
     * @param startDate Fecha desde la cual generar
     * @param daysAhead Cuántos días hacia adelante generar
     * @return Lista de occurrences generadas
     */
    fun generateOccurrences(
        task: Task,
        recurrence: TaskRecurrence?,
        startDate: LocalDate,
        daysAhead: Int = 30
    ): List<TaskOccurrence> {
        val occurrences = mutableListOf<TaskOccurrence>()
        val endDate = startDate.plusDays(daysAhead.toLong())

        when (task.recurrenceType) {
            RecurrenceType.ONCE -> {
                // Solo crear una occurrence para hoy o la fecha de inicio
                occurrences.add(createOccurrence(task.id, startDate))
            }

            RecurrenceType.DAILY -> {
                occurrences.addAll(generateDaily(task.id, recurrence, startDate, endDate))
            }

            RecurrenceType.WEEKLY -> {
                occurrences.addAll(generateWeekly(task.id, recurrence, startDate, endDate))
            }

            RecurrenceType.MONTHLY_FIXED -> {
                occurrences.addAll(generateMonthlyFixed(task.id, recurrence, startDate, endDate))
            }

            RecurrenceType.MONTHLY_PATTERN -> {
                occurrences.addAll(generateMonthlyPattern(task.id, recurrence, startDate, endDate))
            }
        }

        return occurrences
    }

    /**
     * Genera occurrences diarias
     */
    private fun generateDaily(
        taskId: Int,
        recurrence: TaskRecurrence?,
        startDate: LocalDate,
        endDate: LocalDate
    ): List<TaskOccurrence> {
        val occurrences = mutableListOf<TaskOccurrence>()
        val interval = recurrence?.interval ?: 1

        var currentDate = startDate
        while (currentDate <= endDate) {
            occurrences.add(createOccurrence(taskId, currentDate))
            currentDate = currentDate.plusDays(interval.toLong())
        }

        return occurrences
    }

    /**
     * Genera occurrences semanales (días específicos de la semana)
     */
    private fun generateWeekly(
        taskId: Int,
        recurrence: TaskRecurrence?,
        startDate: LocalDate,
        endDate: LocalDate
    ): List<TaskOccurrence> {
        val occurrences = mutableListOf<TaskOccurrence>()
        val daysOfWeek = recurrence?.daysOfWeek ?: emptyList()

        if (daysOfWeek.isEmpty()) return occurrences

        var currentDate = startDate
        while (currentDate <= endDate) {
            val dayOfWeek = mapJavaDayToCustomDay(currentDate.dayOfWeek)
            if (daysOfWeek.contains(dayOfWeek)) {
                occurrences.add(createOccurrence(taskId, currentDate))
            }
            currentDate = currentDate.plusDays(1)
        }

        return occurrences
    }

    /**
     * Genera occurrences mensuales en día fijo (ej: día 15 de cada mes)
     */
    private fun generateMonthlyFixed(
        taskId: Int,
        recurrence: TaskRecurrence?,
        startDate: LocalDate,
        endDate: LocalDate
    ): List<TaskOccurrence> {
        val occurrences = mutableListOf<TaskOccurrence>()
        val dayOfMonth = recurrence?.dayOfMonth ?: return occurrences

        var currentDate = startDate.withDayOfMonth(
            minOf(dayOfMonth, startDate.lengthOfMonth())
        )

        while (currentDate <= endDate) {
            if (currentDate >= startDate) {
                occurrences.add(createOccurrence(taskId, currentDate))
            }
            // Siguiente mes
            currentDate = currentDate.plusMonths(1)
            currentDate = currentDate.withDayOfMonth(
                minOf(dayOfMonth, currentDate.lengthOfMonth())
            )
        }

        return occurrences
    }

    /**
     * Genera occurrences mensuales por patrón
     * (ej: segundo martes de cada mes)
     */
    private fun generateMonthlyPattern(
        taskId: Int,
        recurrence: TaskRecurrence?,
        startDate: LocalDate,
        endDate: LocalDate
    ): List<TaskOccurrence> {
        val occurrences = mutableListOf<TaskOccurrence>()
        val weekOfMonth = recurrence?.weekOfMonth ?: return occurrences
        val weekday = recurrence.weekday ?: return occurrences

        var currentMonth = startDate.withDayOfMonth(1)

        while (currentMonth <= endDate) {
            val occurrenceDate = findNthWeekdayOfMonth(currentMonth, weekOfMonth, weekday)

            if (occurrenceDate != null && occurrenceDate >= startDate && occurrenceDate <= endDate) {
                occurrences.add(createOccurrence(taskId, occurrenceDate))
            }

            currentMonth = currentMonth.plusMonths(1)
        }

        return occurrences
    }

    /**
     * Encuentra el N-ésimo día de la semana en un mes
     * Ejemplo: 2do martes del mes
     */
    private fun findNthWeekdayOfMonth(
        monthStart: LocalDate,
        weekNumber: Int,
        targetWeekday: DayOfWeek
    ): LocalDate? {
        var date = monthStart
        var count = 0

        while (date.monthValue == monthStart.monthValue) {
            val currentDay = mapJavaDayToCustomDay(date.dayOfWeek)
            if (currentDay == targetWeekday) {
                count++
                if (count == weekNumber) {
                    return date
                }
            }
            date = date.plusDays(1)
        }

        return null // No existe ese patrón en el mes
    }

    /**
     * Crea una occurrence básica
     */
    private fun createOccurrence(taskId: Int, date: LocalDate): TaskOccurrence {
        return TaskOccurrence(
            taskId = taskId,
            date = date,
            status = OccurrenceStatus.PENDING,
            createdAt = LocalDateTime.now()
        )
    }

    /**
     * Mapea java.time.DayOfWeek a nuestro DayOfWeek custom
     */
    private fun mapJavaDayToCustomDay(javaDayOfWeek: java.time.DayOfWeek): DayOfWeek {
        return when (javaDayOfWeek) {
            java.time.DayOfWeek.MONDAY -> DayOfWeek.MONDAY
            java.time.DayOfWeek.TUESDAY -> DayOfWeek.TUESDAY
            java.time.DayOfWeek.WEDNESDAY -> DayOfWeek.WEDNESDAY
            java.time.DayOfWeek.THURSDAY -> DayOfWeek.THURSDAY
            java.time.DayOfWeek.FRIDAY -> DayOfWeek.FRIDAY
            java.time.DayOfWeek.SATURDAY -> DayOfWeek.SATURDAY
            java.time.DayOfWeek.SUNDAY -> DayOfWeek.SUNDAY
        }
    }

    /**
     * Calcula cuántos días faltan hasta la próxima occurrence de una tarea
     */
    fun calculateDaysUntilNext(
        task: Task,
        recurrence: TaskRecurrence?,
        fromDate: LocalDate = LocalDate.now()
    ): Long? {
        val nextOccurrences = generateOccurrences(task, recurrence, fromDate, daysAhead = 365)
        val nextOccurrence = nextOccurrences.firstOrNull { it.date >= fromDate }

        return nextOccurrence?.let { ChronoUnit.DAYS.between(fromDate, it.date) }
    }
}
