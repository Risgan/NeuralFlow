enum TaskLogStatus { completed, skipped }

class TaskLog {
	const TaskLog({
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

	TaskLog copyWith({
		int? id,
		int? taskId,
		DateTime? date,
		TaskLogStatus? status,
		DateTime? completedAt,
		DateTime? createdAt,
	}) {
		return TaskLog(
			id: id ?? this.id,
			taskId: taskId ?? this.taskId,
			date: date ?? this.date,
			status: status ?? this.status,
			completedAt: completedAt ?? this.completedAt,
			createdAt: createdAt ?? this.createdAt,
		);
	}
}
