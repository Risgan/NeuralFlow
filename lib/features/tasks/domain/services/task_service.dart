import 'package:neural_flow/core/utils/date_utils.dart';
import 'package:neural_flow/core/utils/recurrence_utils.dart';
import 'package:neural_flow/features/tasks/domain/entities/task.dart';
import 'package:neural_flow/features/tasks/domain/entities/task_log.dart';
import 'package:neural_flow/features/tasks/domain/repositories/task_repository.dart';

class DailyTaskState {
  const DailyTaskState({
    required this.task,
    this.log,
  });

  final Task task;
  final TaskLog? log;

  bool get isCompleted => log?.status == TaskLogStatus.completed;
  bool get isSkipped => log?.status == TaskLogStatus.skipped;
}

class CompletedHistoryItem {
  const CompletedHistoryItem({
    required this.taskId,
    required this.taskTitle,
    required this.date,
    this.time,
    this.completedAt,
  });

  final int taskId;
  final String taskTitle;
  final DateTime date;
  final String? time;
  final DateTime? completedAt;
}

class TaskService {
  TaskService({required TaskRepository repository}) : _repository = repository;

  final TaskRepository _repository;

  Future<List<Task>> getAllTasks({bool includeInactive = true}) {
    return _repository.getAllTasks(includeInactive: includeInactive);
  }

  Future<Task> createTask(Task task) {
    return _repository.createTask(task);
  }

  Future<Task> updateTask(Task task) {
    return _repository.updateTask(task.copyWith(updatedAt: DateTime.now()));
  }

  Future<void> deleteTask(int id) {
    return _repository.deleteTask(id);
  }

  Future<void> setTaskActive(int id, bool active) {
    return _repository.setTaskActive(id, active);
  }

  Future<List<Task>> getTasksForDate(DateTime date) async {
    final activeTasks = await _repository.getActiveTasks();
    return activeTasks
        .where((task) => RecurrenceUtils.appliesToDate(task, date))
        .toList(growable: false);
  }

  Future<List<DailyTaskState>> getDailyTaskStates(DateTime date) async {
    final tasks = await getTasksForDate(date);
    final logs = await _repository.getLogsByDate(date);
    final logsByTaskId = {for (final log in logs) log.taskId: log};

    return tasks
        .map((task) => DailyTaskState(task: task, log: logsByTaskId[task.id]))
        .toList(growable: false);
  }

  Future<List<DailyTaskState>> getPendingTasks(DateTime date) async {
    final states = await getDailyTaskStates(date);
    return states.where((s) => !s.isCompleted).toList(growable: false);
  }

  Future<List<DailyTaskState>> getCompletedTasks(DateTime date) async {
    final states = await getDailyTaskStates(date);
    return states.where((s) => s.isCompleted).toList(growable: false);
  }

  Future<void> markTaskCompleted(int taskId, DateTime date) {
    final now = DateTime.now();
    return _repository.upsertTaskLog(
      TaskLog(
        taskId: taskId,
        date: AppDateUtils.dateOnly(date),
        status: TaskLogStatus.completed,
        completedAt: now,
        createdAt: now,
      ),
    );
  }

  Future<void> markTaskSkipped(int taskId, DateTime date) {
    final now = DateTime.now();
    return _repository.upsertTaskLog(
      TaskLog(
        taskId: taskId,
        date: AppDateUtils.dateOnly(date),
        status: TaskLogStatus.skipped,
        completedAt: null,
        createdAt: now,
      ),
    );
  }

  Future<void> clearTaskLogForDate(int taskId, DateTime date) {
    return _repository.removeTaskLog(taskId, AppDateUtils.dateOnly(date));
  }

  Future<List<CompletedHistoryItem>> getCompletedHistory({
    required DateTime from,
    required DateTime to,
  }) async {
    final logs = await _repository.getLogsByDateRange(from, to);
    final completedLogs = logs
        .where((l) => l.status == TaskLogStatus.completed)
        .toList(growable: false);

    final tasks = await _repository.getAllTasks(includeInactive: true);
    final taskById = {
      for (final task in tasks)
        if (task.id != null) task.id!: task,
    };

    final items = completedLogs
        .map((log) {
          final task = taskById[log.taskId];
          if (task == null) return null;

          return CompletedHistoryItem(
            taskId: log.taskId,
            taskTitle: task.title,
            date: log.date,
            time: task.time,
            completedAt: log.completedAt,
          );
        })
        .whereType<CompletedHistoryItem>()
        .toList(growable: false);

    items.sort((a, b) {
      final aDate = a.completedAt ?? a.date;
      final bDate = b.completedAt ?? b.date;
      return bDate.compareTo(aDate);
    });

    return items;
  }
}
