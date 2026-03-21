import 'package:neural_flow/core/utils/date_utils.dart';
import 'package:neural_flow/features/tasks/domain/entities/task.dart';

class RecurrenceUtils {
	RecurrenceUtils._();

	static bool appliesToDate(Task task, DateTime date) {
		final target = AppDateUtils.dateOnly(date);

		if (!task.active) return false;

		if (task.startDate != null && target.isBefore(AppDateUtils.dateOnly(task.startDate!))) {
			return false;
		}

		if (task.endDate != null && target.isAfter(AppDateUtils.dateOnly(task.endDate!))) {
			return false;
		}

		switch (task.type) {
			case TaskType.once:
				final rawDate = task.config['date'];
				if (rawDate is! String) return false;
				final onceDate = AppDateUtils.parseIsoDate(rawDate);
				return AppDateUtils.isSameDate(onceDate, target);

			case TaskType.daily:
				return true;

			case TaskType.weekly:
				final rawDays = task.config['daysOfWeek'];
				if (rawDays is! List) return false;
				final weekday = _toMondayBasedWeekday(target); // 1..7
				return rawDays.map((d) => d is int ? d : int.tryParse('$d')).contains(weekday);

			case TaskType.monthly:
				final mode = task.config['mode'];
				if (mode == 'dayOfMonth') {
					final day = task.config['day'];
					final dayOfMonth = day is int ? day : int.tryParse('$day');
					if (dayOfMonth == null) return false;
					return target.day == dayOfMonth;
				}

				if (mode == 'pattern') {
					final rawWeekOfMonth = task.config['weekOfMonth'];
					final rawDayOfWeek = task.config['dayOfWeek'];
					if (rawWeekOfMonth is! String) return false;
					final dayOfWeek = rawDayOfWeek is int ? rawDayOfWeek : int.tryParse('$rawDayOfWeek');
					if (dayOfWeek == null) return false;

					return _matchesMonthlyPattern(
						target,
						weekOfMonth: rawWeekOfMonth,
						dayOfWeek: dayOfWeek,
					);
				}

				return false;
		}
	}

	static int _toMondayBasedWeekday(DateTime date) {
		return date.weekday; // DateTime weekday: lunes=1 ... domingo=7
	}

	static bool _matchesMonthlyPattern(
		DateTime date, {
		required String weekOfMonth,
		required int dayOfWeek,
	}) {
		if (date.weekday != dayOfWeek) return false;

		final occurrence = ((date.day - 1) ~/ 7) + 1;
		switch (weekOfMonth) {
			case 'first':
				return occurrence == 1;
			case 'second':
				return occurrence == 2;
			case 'third':
				return occurrence == 3;
			case 'fourth':
				return occurrence == 4;
			case 'last':
				return _isLastWeekdayOfMonth(date);
			default:
				return false;
		}
	}

	static bool _isLastWeekdayOfMonth(DateTime date) {
		final nextWeek = date.add(const Duration(days: 7));
		return nextWeek.month != date.month;
	}
}
