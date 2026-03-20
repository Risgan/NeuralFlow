import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neural_flow/features/tasks/presentation/screens/create_task_screen.dart';
import 'package:neural_flow/features/tasks/presentation/screens/history_screen.dart';
import 'package:neural_flow/features/tasks/presentation/screens/home_screen.dart';
import 'package:neural_flow/features/tasks/presentation/screens/manage_tasks_screen.dart';
import 'package:neural_flow/features/tasks/presentation/screens/shell_screen.dart';

class AppRouter {
  AppRouter._();

  static const String home = '/';
  static const String createTask = '/create-task';
  static const String history = '/history';
  static const String manageTasks = '/manage-tasks';

  static CustomTransitionPage<void> _tabPage({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      transitionDuration: const Duration(milliseconds: 220),
      reverseTransitionDuration: const Duration(milliseconds: 180),
      child: Builder(
        builder: (context) => ColoredBox(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: child,
        ),
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );

        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.02, 0),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      },
    );
  }

  static final GoRouter router = GoRouter(
    initialLocation: home,
    routes: <RouteBase>[
      ShellRoute(
        builder: (context, state, child) => ShellScreen(child: child),
        routes: [
          GoRoute(
            path: home,
            pageBuilder: (BuildContext context, GoRouterState state) =>
                _tabPage(state: state, child: const HomeScreen()),
          ),
          GoRoute(
            path: history,
            pageBuilder: (BuildContext context, GoRouterState state) =>
                _tabPage(state: state, child: const HistoryScreen()),
          ),
          GoRoute(
            path: manageTasks,
            pageBuilder: (BuildContext context, GoRouterState state) =>
                _tabPage(state: state, child: const ManageTasksScreen()),
          ),
        ],
      ),
      GoRoute(
        path: createTask,
        builder: (BuildContext context, GoRouterState state) =>
            const CreateTaskScreen(),
      ),
    ],
    errorBuilder: (BuildContext context, GoRouterState state) {
      return const Scaffold(
        body: Center(
          child: Text('Ruta no encontrada'),
        ),
      );
    },
  );
}
