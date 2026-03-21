import 'package:neural_flow/features/tasks/data/datasources/task_local_datasource.dart';
import 'package:neural_flow/features/tasks/data/models/task_log_model.dart';
import 'package:neural_flow/features/tasks/data/models/task_model.dart';
import 'package:neural_flow/features/tasks/domain/entities/task.dart';
import 'package:neural_flow/features/tasks/domain/entities/task_log.dart';
import 'package:neural_flow/features/tasks/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
	TaskRepositoryImpl({required TaskLocalDataSource localDataSource})
			: _localDataSource = localDataSource;

	final TaskLocalDataSource _localDataSource;

	@override
	Future<List<Task>> getAllTasks({bool includeInactive = true}) async {
		final models = await _localDataSource.getAllTasks(
			includeInactive: includeInactive,
		);
		return models.map((m) => m.toEntity()).toList(growable: false);
	}

	@override
	Future<List<Task>> getActiveTasks() {
		return getAllTasks(includeInactive: false);
	}

	@override
	Future<Task?> getTaskById(int id) async {
		final model = await _localDataSource.getTaskById(id);
		return model?.toEntity();
	}

	@override
	Future<Task> createTask(Task task) async {
		final created = await _localDataSource.createTask(TaskModel.fromEntity(task));
		return created.toEntity();
	}

	@override
	Future<Task> updateTask(Task task) async {
		final updated = await _localDataSource.updateTask(TaskModel.fromEntity(task));
		return updated.toEntity();
	}

	@override
	Future<void> deleteTask(int id) {
		return _localDataSource.deleteTask(id);
	}

	@override
	Future<void> setTaskActive(int id, bool active) {
		return _localDataSource.setTaskActive(id, active);
	}

	@override
	Future<void> upsertTaskLog(TaskLog log) {
		return _localDataSource.upsertTaskLog(TaskLogModel.fromEntity(log));
	}

	@override
	Future<void> removeTaskLog(int taskId, DateTime date) {
		return _localDataSource.deleteTaskLog(taskId, date);
	}

	@override
	Future<TaskLog?> getTaskLogByTaskAndDate(int taskId, DateTime date) async {
		final model = await _localDataSource.getTaskLogByTaskAndDate(taskId, date);
		return model?.toEntity();
	}

	@override
	Future<List<TaskLog>> getLogsByDate(DateTime date) async {
		final models = await _localDataSource.getLogsByDate(date);
		return models.map((m) => m.toEntity()).toList(growable: false);
	}

	@override
	Future<List<TaskLog>> getLogsByDateRange(DateTime from, DateTime to) async {
		final models = await _localDataSource.getLogsByDateRange(from, to);
		return models.map((m) => m.toEntity()).toList(growable: false);
	}
}
