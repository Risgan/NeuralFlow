import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:neural_flow/features/tasks/domain/services/task_service.dart';
import 'package:neural_flow/features/tasks/presentation/providers/task_provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  String _formatDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return 'HOY';
    }
    if (dateOnly == yesterday) {
      return 'AYER';
    }

    return DateFormat('EEEE, d \'de\' MMMM', 'es').format(date).toUpperCase();
  }

  Map<DateTime, List<CompletedHistoryItem>> _groupByDate(
    List<CompletedHistoryItem> items,
  ) {
    final grouped = <DateTime, List<CompletedHistoryItem>>{};

    for (final item in items) {
      final dateOnly = DateTime(item.date.year, item.date.month, item.date.day);
      grouped.putIfAbsent(dateOnly, () => <CompletedHistoryItem>[]).add(item);
    }

    final sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));
    final sortedMap = <DateTime, List<CompletedHistoryItem>>{};
    for (final key in sortedKeys) {
      sortedMap[key] = grouped[key]!;
    }

    return sortedMap;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final groupedTasks = _groupByDate(provider.historyItems);

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 8),
              Text('Historial', style: textTheme.headlineSmall),
              const SizedBox(height: 4),
              Text(
                'Tareas completadas en los ultimos 30 dias',
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
            delegate: SliverChildBuilderDelegate(
              (context, dateIndex) {
                final sortedDates = groupedTasks.keys.toList();
                final date = sortedDates[dateIndex];
                final tasks = groupedTasks[date]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _formatDateHeader(date),
                            style: textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Text(
                          tasks.length.toString(),
                          style: textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...tasks.map((task) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: colorScheme.onSurfaceVariant,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                task.taskTitle,
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                            if (task.time != null)
                              Text(
                                task.time!,
                                style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 16),
                  ],
                );
              },
              childCount: groupedTasks.length,
            ),
          ),
        ),
      ],
    );
  }
}
