import 'package:neural_flow/features/tasks/domain/entities/task.dart';
import 'package:neural_flow/features/tasks/domain/entities/task_log.dart';

abstract class TaskRepository {
	Future<List<Task>> getAllTasks({bool includeInactive = true});
	Future<List<Task>> getActiveTasks();
	Future<Task?> getTaskById(int id);

	Future<Task> createTask(Task task);
	Future<Task> updateTask(Task task);
	Future<void> deleteTask(int id);
	Future<void> setTaskActive(int id, bool active);

	Future<void> upsertTaskLog(TaskLog log);
	Future<void> removeTaskLog(int taskId, DateTime date);
	Future<TaskLog?> getTaskLogByTaskAndDate(int taskId, DateTime date);
	Future<List<TaskLog>> getLogsByDate(DateTime date);
	Future<List<TaskLog>> getLogsByDateRange(DateTime from, DateTime to);
}
