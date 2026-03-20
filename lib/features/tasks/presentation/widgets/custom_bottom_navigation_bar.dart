import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key});

  Widget _buildNavItem({
    required BuildContext context,
    required bool selected,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Expanded(
      child: Tooltip(
        message: tooltip,
        waitDuration: const Duration(milliseconds: 350),
        preferBelow: false,
        verticalOffset: 30,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: selected ? colorScheme.primaryContainer : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    selected ? activeIcon : icon,
                    size: 24,
                    color: selected
                        ? colorScheme.onPrimaryContainer
                        : colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: textTheme.bodySmall?.copyWith(
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                      color: selected
                          ? colorScheme.onPrimaryContainer
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  int _getIndexFromLocation(String location) {
    // Mapear la ruta actual al índice
    if (location == '/') return 0;
    if (location == '/history') return 1;
    if (location == '/manage-tasks') return 2;
    return 0;
  }

  void _navigateTo(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/history');
        break;
      case 2:
        context.go('/manage-tasks');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final currentLocation = GoRouterState.of(context).uri.path;
    final currentIndex = _getIndexFromLocation(currentLocation);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: Container(
          color: colorScheme.surface,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              _buildNavItem(
                context: context,
                selected: currentIndex == 0,
                icon: Icons.task_outlined,
                activeIcon: Icons.task,
                label: 'Hoy',
                tooltip: 'Tareas del dia',
                onTap: () => _navigateTo(context, 0),
              ),
              _buildNavItem(
                context: context,
                selected: currentIndex == 1,
                icon: Icons.calendar_month_outlined,
                activeIcon: Icons.calendar_month,
                label: 'Historial',
                tooltip: 'Historial de tareas',
                onTap: () => _navigateTo(context, 1),
              ),
              _buildNavItem(
                context: context,
                selected: currentIndex == 2,
                icon: Icons.list_alt_outlined,
                activeIcon: Icons.list_alt,
                label: 'Tareas',
                tooltip: 'Administrar tareas',
                onTap: () => _navigateTo(context, 2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}