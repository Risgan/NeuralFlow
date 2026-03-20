import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
	const HistoryScreen({super.key});

	@override
	Widget build(BuildContext context) {
		final textTheme = Theme.of(context).textTheme;

		return Center(
			child: Text(
				'Historial',
				style: textTheme.bodyLarge,
			),
		);
	}
}
