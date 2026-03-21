import 'package:neural_flow/features/tasks/domain/entities/task.dart';
import 'package:neural_flow/features/tasks/presentation/screens/create_task_screen.dart';

class TaskFormMapper {
  TaskFormMapper._();

  static Task fromCreateResult(CreateTaskResult result) {
    final now = DateTime.now();
    return Task(
      title: result.title,
      notes: null,
      type: _toTaskType(result.frequency),
      config: _toConfig(result),
      time: result.time,
      active: true,
      createdAt: now,
      updatedAt: now,
    );
  }

  static Task applyCreateResult(Task current, CreateTaskResult result) {
    return current.copyWith(
      title: result.title,
      type: _toTaskType(result.frequency),
      config: _toConfig(result),
      time: result.time,
      updatedAt: DateTime.now(),
    );
  }

  static CreateTaskResult toCreateResult(Task task) {
    final frequency = _toTaskFrequency(task.type);

    DateTime? unicaDate;
    List<int>? weekDays;
    MonthScheduleType? monthScheduleType;
    int? monthSpecificDay;
    int? monthWeek;
    int? monthWeekDay;

    switch (task.type) {
      case TaskType.once:
        final date = task.config['date'];
        if (date is String) {
          unicaDate = DateTime.tryParse(date);
        }
        break;
      case TaskType.daily:
        break;
      case TaskType.weekly:
        final days = task.config['daysOfWeek'];
        if (days is List) {
          weekDays = days
              .map((d) => d is int ? d : int.tryParse('$d'))
              .whereType<int>()
              .map(_dbWeekdayToFormWeekday)
              .toList(growable: false);
        }
        break;
      case TaskType.monthly:
        final mode = task.config['mode'];
        if (mode == 'dayOfMonth') {
          monthScheduleType = MonthScheduleType.specificDay;
          final day = task.config['day'];
          monthSpecificDay = day is int ? day : int.tryParse('$day');
        } else if (mode == 'pattern') {
          monthScheduleType = MonthScheduleType.weekPattern;
          final week = task.config['weekOfMonth'];
          final weekday = task.config['dayOfWeek'];
          monthWeek = _weekOfMonthToIndex(week as String?);
          final dbWeekday = weekday is int ? weekday : int.tryParse('$weekday');
          monthWeekDay = dbWeekday == null ? null : _dbWeekdayToFormWeekday(dbWeekday);
        }
        break;
    }

    return CreateTaskResult(
      title: task.title,
      time: task.time,
      frequency: frequency,
      unicaDate: unicaDate,
      weekDays: weekDays,
      monthScheduleType: monthScheduleType,
      monthSpecificDay: monthSpecificDay,
      monthWeek: monthWeek,
      monthWeekDay: monthWeekDay,
    );
  }

  static TaskType _toTaskType(TaskFrequency frequency) {
    switch (frequency) {
      case TaskFrequency.unica:
        return TaskType.once;
      case TaskFrequency.diaria:
        return TaskType.daily;
      case TaskFrequency.semanal:
        return TaskType.weekly;
      case TaskFrequency.mensual:
        return TaskType.monthly;
    }
  }

  static TaskFrequency _toTaskFrequency(TaskType type) {
    switch (type) {
      case TaskType.once:
        return TaskFrequency.unica;
      case TaskType.daily:
        return TaskFrequency.diaria;
      case TaskType.weekly:
        return TaskFrequency.semanal;
      case TaskType.monthly:
        return TaskFrequency.mensual;
    }
  }

  static Map<String, dynamic> _toConfig(CreateTaskResult result) {
    switch (result.frequency) {
      case TaskFrequency.unica:
        return {
          'date': (result.unicaDate ?? DateTime.now()).toIso8601String().split('T').first,
        };
      case TaskFrequency.diaria:
        return {
          'interval': 1,
        };
      case TaskFrequency.semanal:
        return {
          'daysOfWeek': (result.weekDays ?? const <int>[])
              .map(_formWeekdayToDbWeekday)
              .toList(growable: false),
        };
      case TaskFrequency.mensual:
        if (result.monthScheduleType == MonthScheduleType.weekPattern) {
          return {
            'mode': 'pattern',
            'weekOfMonth': _indexToWeekOfMonth(result.monthWeek ?? 0),
            'dayOfWeek': _formWeekdayToDbWeekday(result.monthWeekDay ?? 0),
          };
        }

        return {
          'mode': 'dayOfMonth',
          'day': result.monthSpecificDay ?? 1,
        };
    }
  }

  static int _formWeekdayToDbWeekday(int formDay) {
    // Form: 0=Lun ... 6=Dom, DB: 1=Lun ... 7=Dom
    return formDay + 1;
  }

  static int _dbWeekdayToFormWeekday(int dbDay) {
    return (dbDay - 1).clamp(0, 6);
  }

  static String _indexToWeekOfMonth(int index) {
    switch (index) {
      case 0:
        return 'first';
      case 1:
        return 'second';
      case 2:
        return 'third';
      case 3:
        return 'fourth';
      case 4:
        return 'last';
      default:
        return 'first';
    }
  }

  static int _weekOfMonthToIndex(String? value) {
    switch (value) {
      case 'first':
        return 0;
      case 'second':
        return 1;
      case 'third':
        return 2;
      case 'fourth':
        return 3;
      case 'last':
        return 4;
      default:
        return 0;
    }
  }
}
