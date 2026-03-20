import 'package:flutter/material.dart';
import 'package:neural_flow/features/tasks/presentation/widgets/custom_appbar.dart';
import 'package:neural_flow/features/tasks/presentation/widgets/custom_bottom_navigation_bar.dart';

class ShellScreen extends StatelessWidget {
  final Widget child;

  const ShellScreen({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(title: 'Neural Flow', pendingTasks: 5),
            Expanded(child: child),
            const CustomBottomNavigationBar(),
          ],
        ),
      ),
    );
  }
}
