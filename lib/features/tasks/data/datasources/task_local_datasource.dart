import 'package:neural_flow/core/database/database_helper.dart';
import 'package:neural_flow/core/utils/date_utils.dart';
import 'package:neural_flow/features/tasks/data/models/task_log_model.dart';
import 'package:neural_flow/features/tasks/data/models/task_model.dart';
import 'package:sqflite/sqflite.dart';

abstract class TaskLocalDataSource {
	Future<TaskModel> createTask(TaskModel task);
	Future<TaskModel> updateTask(TaskModel task);
	Future<void> deleteTask(int id);
	Future<void> setTaskActive(int id, bool active);
	Future<TaskModel?> getTaskById(int id);
	Future<List<TaskModel>> getAllTasks({bool includeInactive = true});

	Future<void> upsertTaskLog(TaskLogModel log);
	Future<void> deleteTaskLog(int taskId, DateTime date);
	Future<TaskLogModel?> getTaskLogByTaskAndDate(int taskId, DateTime date);
	Future<List<TaskLogModel>> getLogsByDate(DateTime date);
	Future<List<TaskLogModel>> getLogsByDateRange(DateTime from, DateTime to);
}

class SqfliteTaskLocalDataSource implements TaskLocalDataSource {
	SqfliteTaskLocalDataSource({required DatabaseHelper databaseHelper})
			: _databaseHelper = databaseHelper;

	final DatabaseHelper _databaseHelper;

	@override
	Future<TaskModel> createTask(TaskModel task) async {
		final db = await _databaseHelper.database;
		final id = await db.insert('tasks', task.toMap()..remove('id'));
		return TaskModel(
			id: id,
			title: task.title,
			notes: task.notes,
			type: task.type,
			config: task.config,
			time: task.time,
			active: task.active,
			startDate: task.startDate,
			endDate: task.endDate,
			createdAt: task.createdAt,
			updatedAt: task.updatedAt,
		);
	}

	@override
	Future<TaskModel> updateTask(TaskModel task) async {
		if (task.id == null) {
			throw ArgumentError('No se puede actualizar una tarea sin id');
		}

		final db = await _databaseHelper.database;
		await db.update(
			'tasks',
			task.toMap()..remove('id'),
			where: 'id = ?',
			whereArgs: [task.id],
			conflictAlgorithm: ConflictAlgorithm.abort,
		);
		return task;
	}

	@override
	Future<void> deleteTask(int id) async {
		final db = await _databaseHelper.database;
		await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
	}

	@override
	Future<void> setTaskActive(int id, bool active) async {
		final db = await _databaseHelper.database;
		await db.update(
			'tasks',
			{
				'active': active ? 1 : 0,
				'updated_at': AppDateUtils.toIsoDateTime(DateTime.now()),
			},
			where: 'id = ?',
			whereArgs: [id],
		);
	}

	@override
	Future<TaskModel?> getTaskById(int id) async {
		final db = await _databaseHelper.database;
		final result = await db.query('tasks', where: 'id = ?', whereArgs: [id], limit: 1);
		if (result.isEmpty) return null;
		return TaskModel.fromMap(result.first);
	}

	@override
	Future<List<TaskModel>> getAllTasks({bool includeInactive = true}) async {
		final db = await _databaseHelper.database;
		final result = await db.query(
			'tasks',
			where: includeInactive ? null : 'active = 1',
			orderBy: 'created_at DESC',
		);
		return result.map(TaskModel.fromMap).toList(growable: false);
	}

	@override
	Future<void> upsertTaskLog(TaskLogModel log) async {
		final db = await _databaseHelper.database;
		await db.insert(
			'task_logs',
			log.toMap()..remove('id'),
			conflictAlgorithm: ConflictAlgorithm.replace,
		);
	}

	@override
	Future<void> deleteTaskLog(int taskId, DateTime date) async {
		final db = await _databaseHelper.database;
		await db.delete(
			'task_logs',
			where: 'task_id = ? AND date = ?',
			whereArgs: [taskId, AppDateUtils.toIsoDate(date)],
		);
	}

	@override
	Future<TaskLogModel?> getTaskLogByTaskAndDate(int taskId, DateTime date) async {
		final db = await _databaseHelper.database;
		final result = await db.query(
			'task_logs',
			where: 'task_id = ? AND date = ?',
			whereArgs: [taskId, AppDateUtils.toIsoDate(date)],
			limit: 1,
		);
		if (result.isEmpty) return null;
		return TaskLogModel.fromMap(result.first);
	}

	@override
	Future<List<TaskLogModel>> getLogsByDate(DateTime date) async {
		final db = await _databaseHelper.database;
		final result = await db.query(
			'task_logs',
			where: 'date = ?',
			whereArgs: [AppDateUtils.toIsoDate(date)],
			orderBy: 'created_at DESC',
		);
		return result.map(TaskLogModel.fromMap).toList(growable: false);
	}

	@override
	Future<List<TaskLogModel>> getLogsByDateRange(DateTime from, DateTime to) async {
		final db = await _databaseHelper.database;
		final result = await db.query(
			'task_logs',
			where: 'date >= ? AND date <= ?',
			whereArgs: [
				AppDateUtils.toIsoDate(from),
				AppDateUtils.toIsoDate(to),
			],
			orderBy: 'date DESC, created_at DESC',
		);
		return result.map(TaskLogModel.fromMap).toList(growable: false);
	}
}
