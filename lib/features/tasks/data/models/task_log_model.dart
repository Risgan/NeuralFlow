import 'package:neural_flow/core/utils/date_utils.dart';
import 'package:neural_flow/features/tasks/domain/entities/task_log.dart';

class TaskLogModel {
	const TaskLogModel({
		this.id,
		required this.taskId,
		required this.date,
		required this.status,
		this.completedAt,
		required this.createdAt,
	});

	final int? id;
	final int taskId;
	final DateTime date;
	final TaskLogStatus status;
	final DateTime? completedAt;
	final DateTime createdAt;

	TaskLog toEntity() {
		return TaskLog(
			id: id,
			taskId: taskId,
			date: date,
			status: status,
			completedAt: completedAt,
			createdAt: createdAt,
		);
	}

	factory TaskLogModel.fromEntity(TaskLog log) {
		return TaskLogModel(
			id: log.id,
			taskId: log.taskId,
			date: log.date,
			status: log.status,
			completedAt: log.completedAt,
			createdAt: log.createdAt,
		);
	}

	factory TaskLogModel.fromMap(Map<String, Object?> map) {
		return TaskLogModel(
			id: map['id'] as int?,
			taskId: map['task_id'] as int,
			date: AppDateUtils.parseIsoDate(map['date'] as String),
			status: _statusFromDb(map['status'] as String),
			completedAt: (map['completed_at'] as String?) == null
					? null
					: AppDateUtils.parseIsoDateTime(map['completed_at'] as String),
			createdAt: AppDateUtils.parseIsoDateTime(map['created_at'] as String),
		);
	}

	Map<String, Object?> toMap() {
		return {
			'id': id,
			'task_id': taskId,
			'date': AppDateUtils.toIsoDate(date),
			'status': _statusToDb(status),
			'completed_at': completedAt == null ? null : AppDateUtils.toIsoDateTime(completedAt!),
			'created_at': AppDateUtils.toIsoDateTime(createdAt),
		};
	}

	static TaskLogStatus _statusFromDb(String value) {
		switch (value) {
			case 'completed':
				return TaskLogStatus.completed;
			case 'skipped':
				return TaskLogStatus.skipped;
			default:
				throw ArgumentError('Estado de log desconocido: $value');
		}
	}

	static String _statusToDb(TaskLogStatus value) {
		switch (value) {
			case TaskLogStatus.completed:
				return 'completed';
			case TaskLogStatus.skipped:
				return 'skipped';
		}
	}
}
