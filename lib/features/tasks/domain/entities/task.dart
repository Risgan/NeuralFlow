enum TaskType { once, daily, weekly, monthly }

enum MonthlyRecurrenceMode { dayOfMonth, pattern }

enum WeekOfMonth { first, second, third, fourth, last }

class Task {
	const Task({
		this.id,
		required this.title,
		this.notes,
		required this.type,
		required this.config,
		this.time,
		this.active = true,
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

	Task copyWith({
		int? id,
		String? title,
		String? notes,
		TaskType? type,
		Map<String, dynamic>? config,
		String? time,
		bool? active,
		DateTime? startDate,
		DateTime? endDate,
		DateTime? createdAt,
		DateTime? updatedAt,
	}) {
		return Task(
			id: id ?? this.id,
			title: title ?? this.title,
			notes: notes ?? this.notes,
			type: type ?? this.type,
			config: config ?? this.config,
			time: time ?? this.time,
			active: active ?? this.active,
			startDate: startDate ?? this.startDate,
			endDate: endDate ?? this.endDate,
			createdAt: createdAt ?? this.createdAt,
			updatedAt: updatedAt ?? this.updatedAt,
		);
	}
}
