import 'dart:convert';

import 'package:neural_flow/core/utils/date_utils.dart';
import 'package:neural_flow/features/tasks/domain/entities/task.dart';

class TaskModel {
	const TaskModel({
		this.id,
		required this.title,
		this.notes,
		required this.type,
		required this.config,
		this.time,
		required this.active,
		this.startDate,
		this.endDate,
		required this.createdAt,
		required this.updatedAt,
	});

	final int? id;
	final String title;
	final String? notes;
	final TaskType type;
	final Map<String, dynamic> config;
	final String? time;
	final bool active;
	final DateTime? startDate;
	final DateTime? endDate;
	final DateTime createdAt;
	final DateTime updatedAt;

	Task toEntity() {
		return Task(
			id: id,
			title: title,
			notes: notes,
			type: type,
			config: config,
			time: time,
			active: active,
			startDate: startDate,
			endDate: endDate,
			createdAt: createdAt,
			updatedAt: updatedAt,
		);
	}

	factory TaskModel.fromEntity(Task task) {
		return TaskModel(
			id: task.id,
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

	factory TaskModel.fromMap(Map<String, Object?> map) {
		return TaskModel(
			id: map['id'] as int?,
			title: map['title'] as String,
			notes: map['notes'] as String?,
			type: _typeFromDb(map['type'] as String),
			config: _configFromDb(map['config_json'] as String),
			time: map['time'] as String?,
			active: (map['active'] as int) == 1,
			startDate: (map['start_date'] as String?) == null
					? null
					: AppDateUtils.parseIsoDate(map['start_date'] as String),
			endDate: (map['end_date'] as String?) == null
					? null
					: AppDateUtils.parseIsoDate(map['end_date'] as String),
			createdAt: AppDateUtils.parseIsoDateTime(map['created_at'] as String),
			updatedAt: AppDateUtils.parseIsoDateTime(map['updated_at'] as String),
		);
	}

	Map<String, Object?> toMap() {
		return {
			'id': id,
			'title': title,
			'notes': notes,
			'type': _typeToDb(type),
			'config_json': jsonEncode(config),
			'time': time,
			'active': active ? 1 : 0,
			'start_date': startDate == null ? null : AppDateUtils.toIsoDate(startDate!),
			'end_date': endDate == null ? null : AppDateUtils.toIsoDate(endDate!),
			'created_at': AppDateUtils.toIsoDateTime(createdAt),
			'updated_at': AppDateUtils.toIsoDateTime(updatedAt),
		};
	}

	static TaskType _typeFromDb(String value) {
		switch (value) {
			case 'once':
				return TaskType.once;
			case 'daily':
				return TaskType.daily;
			case 'weekly':
				return TaskType.weekly;
			case 'monthly':
				return TaskType.monthly;
			default:
				throw ArgumentError('Tipo de tarea desconocido: $value');
		}
	}

	static String _typeToDb(TaskType value) {
		switch (value) {
			case TaskType.once:
				return 'once';
			case TaskType.daily:
				return 'daily';
			case TaskType.weekly:
				return 'weekly';
			case TaskType.monthly:
				return 'monthly';
		}
	}

	static Map<String, dynamic> _configFromDb(String jsonValue) {
		final decoded = jsonDecode(jsonValue);
		if (decoded is! Map<String, dynamic>) {
			throw const FormatException('config_json invalido');
		}
		return decoded;
	}
}
