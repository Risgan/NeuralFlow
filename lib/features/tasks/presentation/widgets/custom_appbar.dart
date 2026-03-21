import 'package:flutter/material.dart';
// import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:neural_flow/core/constants/theme_controller.dart';

class CustomAppBar extends StatelessWidget {

  final String title;
  final int pendingTasks;
  final List<Widget>? actions;

  const CustomAppBar({
    super.key,
    required this.title,
    required this.pendingTasks,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final themeController = context.watch<ThemeController>();

    return SafeArea(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                // Icon(Icons.sunny, color: colors.primary),
                const SizedBox(width: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: textTheme.titleLarge),
                    if (pendingTasks == 1)Text(
                        '$pendingTasks tarea pendiente',
                        style: textTheme.bodySmall,
                      )
                    else if (pendingTasks > 1)
                      Text(
                        '$pendingTasks tareas pendientes',
                        style: textTheme.bodySmall,
                      )
                    else
                      Text(
                        'tareas completadas',
                        style: textTheme.bodySmall,
                      ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  color: colors.primary,
                  // splashColor: Colors.red,
                  // highlightColor: Colors.blue,
                  style: IconButton.styleFrom(
                    padding: const EdgeInsets.all(8),
                    backgroundColor: colors.primaryContainer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {
                    themeController.toggleLightDark();
                    print('Toggled theme mode: ${themeController.themeMode}');
                  },
                  icon: ThemeMode.dark == themeController.themeMode ? 
                    Icon(Icons.wb_sunny_outlined, color: colors.primary) : 
                    Icon(Icons.bedtime_outlined, color: colors.primary,),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
