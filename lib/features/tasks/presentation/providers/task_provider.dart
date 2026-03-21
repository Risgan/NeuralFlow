import 'package:flutter/foundation.dart';
import 'package:neural_flow/core/utils/date_utils.dart';
import 'package:neural_flow/features/tasks/domain/entities/task.dart';
import 'package:neural_flow/features/tasks/domain/services/task_service.dart';

class TaskProvider extends ChangeNotifier {
	TaskProvider({required TaskService taskService}) : _taskService = taskService;

	final TaskService _taskService;

	bool _isLoading = false;
	String? _errorMessage;
	DateTime _selectedDate = AppDateUtils.dateOnly(DateTime.now());
	List<Task> _manageTasks = const [];
	List<DailyTaskState> _dailyStates = const [];
	List<CompletedHistoryItem> _historyItems = const [];

	bool get isLoading => _isLoading;
	String? get errorMessage => _errorMessage;
	DateTime get selectedDate => _selectedDate;
	List<Task> get manageTasks => _manageTasks;
	List<DailyTaskState> get dailyStates => _dailyStates;
	List<CompletedHistoryItem> get historyItems => _historyItems;

	List<DailyTaskState> get pendingStates {
		return _dailyStates.where((s) => !s.isCompleted).toList(growable: false);
	}

	List<DailyTaskState> get completedStates {
		return _dailyStates.where((s) => s.isCompleted).toList(growable: false);
	}

	Future<void> initialize() async {
		await _runWithState(() async {
			await _reloadAll();
		});
	}

	Future<void> loadManageTasks() async {
		await _runWithState(() async {
			_manageTasks = await _taskService.getAllTasks(includeInactive: true);
		});
	}

	Future<void> loadForDate(DateTime date) async {
		await _runWithState(() async {
			_selectedDate = AppDateUtils.dateOnly(date);
			_dailyStates = await _taskService.getDailyTaskStates(_selectedDate);
		});
	}

	Future<void> createTask(Task task) async {
		await _runWithState(() async {
			await _taskService.createTask(task);
			await _reloadAll();
		});
	}

	Future<void> updateTask(Task task) async {
		await _runWithState(() async {
			await _taskService.updateTask(task);
			await _reloadAll();
		});
	}

	Future<void> deleteTask(int taskId) async {
		await _runWithState(() async {
			await _taskService.deleteTask(taskId);
			await _reloadAll();
		});
	}

	Future<void> setTaskActive(int taskId, bool active) async {
		await _runWithState(() async {
			await _taskService.setTaskActive(taskId, active);
			await _reloadAll();
		});
	}

	Future<void> markCompleted(int taskId, DateTime date) async {
		await _runWithState(() async {
			await _taskService.markTaskCompleted(taskId, date);
			await _reloadAll();
		});
	}

	Future<void> clearCompletion(int taskId, DateTime date) async {
		await _runWithState(() async {
			await _taskService.clearTaskLogForDate(taskId, date);
			await _reloadAll();
		});
	}

	Future<void> _reloadAll() async {
		_manageTasks = await _taskService.getAllTasks(includeInactive: true);
		_dailyStates = await _taskService.getDailyTaskStates(_selectedDate);
		final to = AppDateUtils.dateOnly(DateTime.now());
		final from = to.subtract(const Duration(days: 30));
		_historyItems = await _taskService.getCompletedHistory(from: from, to: to);
	}

	Future<void> _runWithState(Future<void> Function() action) async {
		_isLoading = true;
		_errorMessage = null;
		notifyListeners();

		try {
			await action();
		} catch (e) {
			_errorMessage = e.toString();
			rethrow;
		} finally {
			_isLoading = false;
			notifyListeners();
		}
	}
}
