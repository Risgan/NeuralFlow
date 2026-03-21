import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:neural_flow/features/tasks/domain/entities/task.dart';
import 'package:neural_flow/features/tasks/presentation/providers/task_provider.dart';
import 'package:neural_flow/features/tasks/presentation/screens/create_task_screen.dart';
import 'package:neural_flow/features/tasks/presentation/utils/task_form_mapper.dart';

class ManageTasksScreen extends StatelessWidget {
  const ManageTasksScreen({super.key});

  String _getFrequencyLabel(Task task) {
    switch (task.type) {
      case TaskType.once:
        return 'Unica';
      case TaskType.daily:
        return 'Diaria';
      case TaskType.weekly:
        final rawDays = task.config['daysOfWeek'];
        if (rawDays is! List || rawDays.isEmpty) return 'Semanal';

        const dbDayLabels = ['L', 'M', 'W', 'J', 'V', 'S', 'D'];
        final selected = rawDays
            .map((d) => d is int ? d : int.tryParse('$d'))
            .whereType<int>()
            .map((dbDay) => dbDayLabels[(dbDay - 1).clamp(0, 6)])
            .join(', ');

        return 'Semanal: $selected';
      case TaskType.monthly:
        final mode = task.config['mode'];
        if (mode == 'dayOfMonth') {
          return 'Mensual: dia ${task.config['day']}';
        }

        if (mode == 'pattern') {
          final week = task.config['weekOfMonth'] as String?;
          final rawDay = task.config['dayOfWeek'];
          final day = rawDay is int ? rawDay : int.tryParse('$rawDay');

          const weeks = {
            'first': 'Primera',
            'second': 'Segunda',
            'third': 'Tercera',
            'fourth': 'Cuarta',
            'last': 'Ultima',
          };
          const days = ['L', 'M', 'W', 'J', 'V', 'S', 'D'];

          final weekLabel = weeks[week] ?? 'Primera';
          final dayLabel = day == null ? 'L' : days[(day - 1).clamp(0, 6)];
          return 'Mensual: $weekLabel $dayLabel';
        }

        return 'Mensual';
    }
  }

  Future<void> _confirmToggleTask(BuildContext context, Task task) async {
    final taskId = task.id;
    if (taskId == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(task.active ? 'Desactivar tarea' : 'Activar tarea'),
        content: Text(
          '¿${task.active ? 'Desactivar' : 'Activar'} "${task.title}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Si'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;
    await context.read<TaskProvider>().setTaskActive(taskId, !task.active);
  }

  Future<void> _confirmDeleteTask(BuildContext context, Task task) async {
    final taskId = task.id;
    if (taskId == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar tarea'),
        content: Text(
          '¿Eliminar "${task.title}"? Esta accion no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Si'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;
    await context.read<TaskProvider>().deleteTask(taskId);
  }

  Future<void> _editTask(BuildContext context, Task task) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) {
        return CreateTaskFormSheet(
          initialData: TaskFormMapper.toCreateResult(task),
          isEditMode: true,
          onClose: () => Navigator.of(sheetContext).pop(),
          onSubmit: (result) async {
            final updated = TaskFormMapper.applyCreateResult(task, result);
            await context.read<TaskProvider>().updateTask(updated);
            if (sheetContext.mounted) {
              Navigator.of(sheetContext).pop();
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final activeTasks = provider.manageTasks.where((t) => t.active).toList();
    final inactiveTasks = provider.manageTasks.where((t) => !t.active).toList();

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 8),
              Text('Gestionar tareas', style: textTheme.headlineSmall),
              const SizedBox(height: 4),
              Text(
                '${provider.manageTasks.length} tareas en total',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
            ]),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Row(
                children: [
                  Text(
                    'ACTIVAS',
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    activeTasks.length.toString(),
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...activeTasks.map((task) {
                return _buildTaskCard(context, task, colorScheme, textTheme);
              }),
              const SizedBox(height: 20),
              if (inactiveTasks.isNotEmpty) ...[
                Row(
                  children: [
                    Text(
                      'INACTIVAS',
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      inactiveTasks.length.toString(),
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...inactiveTasks.map((task) {
                  return _buildTaskCard(context, task, colorScheme, textTheme);
                }),
              ],
              const SizedBox(height: 20),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildTaskCard(
    BuildContext context,
    Task task,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final isInactive = !task.active;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isInactive
            ? colorScheme.surface.withOpacity(0.5)
            : colorScheme.surface,
        border: Border.all(color: colorScheme.outlineVariant, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: textTheme.bodyMedium?.copyWith(
                          color: isInactive
                              ? colorScheme.onSurfaceVariant
                              : colorScheme.onSurface,
                          decoration: isInactive
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      if (task.time != null) ...[
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 14,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              task.time!,
                              style: textTheme.labelSmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.repeat,
                            size: 14,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _getFrequencyLabel(task),
                            style: textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Tooltip(
                      message: task.active ? 'Desactivar' : 'Activar',
                      child: IconButton(
                        onPressed: () => _confirmToggleTask(context, task),
                        icon: Icon(
                          Icons.power_settings_new,
                          color: task.active
                              ? colorScheme.primary
                              : colorScheme.onSurfaceVariant,
                        ),
                        constraints: const BoxConstraints(
                          minHeight: 36,
                          minWidth: 36,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                    Tooltip(
                      message: 'Editar',
                      child: IconButton(
                        onPressed: () => _editTask(context, task),
                        icon: Icon(Icons.edit, color: colorScheme.primary),
                        constraints: const BoxConstraints(
                          minHeight: 36,
                          minWidth: 36,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                    Tooltip(
                      message: 'Eliminar',
                      child: IconButton(
                        onPressed: () => _confirmDeleteTask(context, task),
                        icon: Icon(Icons.delete, color: colorScheme.error),
                        constraints: const BoxConstraints(
                          minHeight: 36,
                          minWidth: 36,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
