import 'package:flutter/material.dart';

class ManageTasksScreen extends StatelessWidget {
	const ManageTasksScreen({super.key});

	@override
	Widget build(BuildContext context) {
		final textTheme = Theme.of(context).textTheme;

		return Center(
			child: Text(
				'Gestionar Tareas',
				style: textTheme.bodyLarge,
			),
		);
	}
}
