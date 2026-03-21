class AppDateUtils {
	AppDateUtils._();

	static DateTime dateOnly(DateTime date) {
		return DateTime(date.year, date.month, date.day);
	}

	static bool isSameDate(DateTime a, DateTime b) {
		return a.year == b.year && a.month == b.month && a.day == b.day;
	}

	static String toIsoDate(DateTime date) {
		final only = dateOnly(date);
		final mm = only.month.toString().padLeft(2, '0');
		final dd = only.day.toString().padLeft(2, '0');
		return '${only.year}-$mm-$dd';
	}

	static DateTime parseIsoDate(String value) {
		final pieces = value.split('-');
		if (pieces.length != 3) {
			throw FormatException('Fecha invalida: $value');
		}

		return DateTime(
			int.parse(pieces[0]),
			int.parse(pieces[1]),
			int.parse(pieces[2]),
		);
	}

	static String toIsoDateTime(DateTime dateTime) {
		return dateTime.toIso8601String();
	}

	static DateTime parseIsoDateTime(String value) {
		return DateTime.parse(value);
	}
}
