import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:neural_flow/features/tasks/domain/services/task_service.dart';
import 'package:neural_flow/features/tasks/presentation/providers/task_provider.dart';
import 'package:neural_flow/features/tasks/presentation/screens/create_task_screen.dart';
import 'package:neural_flow/features/tasks/presentation/utils/task_form_mapper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _formatTodayLabel() {
    final dateText = DateFormat(
      'EEEE, d \'de\' MMMM',
      'es_ES',
    ).format(DateTime.now());
    return '${dateText[0].toUpperCase()}${dateText.substring(1)}';
  }

  List<DailyTaskState> _sortByTime(List<DailyTaskState> tasks) {
    final sorted = [...tasks];
    sorted.sort((a, b) {
      final aTime = a.task.time;
      final bTime = b.task.time;
      if (aTime == null && bTime == null) return 0;
      if (aTime == null) return 1;
      if (bTime == null) return -1;
      return aTime.compareTo(bTime);
    });
    return sorted;
  }

  Future<void> _toggleTaskStatus(DailyTaskState state) async {
    final taskId = state.task.id;
    if (taskId == null) return;

    final provider = context.read<TaskProvider>();
    final date = provider.selectedDate;
    if (state.isCompleted) {
      await provider.clearCompletion(taskId, date);
      return;
    }
    await provider.markCompleted(taskId, date);
  }

  Future<void> _showCreateTaskSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return CreateTaskFormSheet(
          onClose: () => Navigator.of(sheetContext).pop(),
          onSubmit: (result) async {
            final task = TaskFormMapper.fromCreateResult(result);
            await context.read<TaskProvider>().createTask(task);
            Navigator.of(sheetContext).pop();
          },
        );
      },
    );
  }

  Widget _taskTile(BuildContext context, DailyTaskState state) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final task = state.task;

    return Card(
      key: ValueKey(task.id ?? task.title),
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: () async {
          await _toggleTaskStatus(state);
        },
        leading: Icon(
          state.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
          color: state.isCompleted
              ? colorScheme.primary
              : colorScheme.onSurfaceVariant,
        ),
        title: Row(
          children: [
            Text(task.title, style: textTheme.bodyLarge),
            Spacer(),
            if (task.time != null) ...[
              Icon(
                Icons.access_time,
                size: 16,
                color: colorScheme.onSurfaceVariant,
              ),
              Text('${task.time}', style: textTheme.bodyLarge),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();
    final textTheme = Theme.of(context).textTheme;
    final pending = _sortByTime(provider.pendingStates);
    final done = _sortByTime(provider.completedStates);
    final dateLabel = _formatTodayLabel();

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          child: Column(
            children: [
              Text(
                dateLabel,
                style: textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              Text(
                '${pending.length}',
                style: textTheme.displayLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              if (pending.isNotEmpty) ...[
                Text(
                  'tarea${pending.length == 1 ? '' : 's'} pendiente${pending.length == 1 ? '' : 's'} hoy',
                  style: textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ] else
                Text(
                  '¡No hay tareas pendientes para hoy!',
                  style: textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 50),
                  children: [
                    if (pending.isNotEmpty) ...[
                      for (final task in pending) _taskTile(context, task),
                    ],
                    if (done.isNotEmpty) ...[
                      const SizedBox(height: 14),
                      Text(
                        'Completadas · ${done.length}',
                        style: textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      for (final task in done) _taskTile(context, task),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: 20,
          bottom: 16,
          child: FloatingActionButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            onPressed: _showCreateTaskSheet,
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
