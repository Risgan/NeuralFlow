import 'dart:developer' as developer;

import 'package:sqflite/sqflite.dart';

class AppMigrations {
	AppMigrations._();

	static const int currentVersion = 1;

	static Future<void> onCreate(Database db, int version) async {
		for (var v = 1; v <= version; v++) {
			await _runMigration(db, v);
		}
	}

	static Future<void> onUpgrade(Database db, int oldVersion, int newVersion) async {
		for (var v = oldVersion + 1; v <= newVersion; v++) {
			await _runMigration(db, v);
		}
	}

	static Future<void> _runMigration(Database db, int version) async {
		developer.log('Running migration v$version', name: 'AppMigrations');

		switch (version) {
			case 1:
				await db.execute('''
					CREATE TABLE IF NOT EXISTS tasks (
						id INTEGER PRIMARY KEY AUTOINCREMENT,
						title TEXT NOT NULL,
						notes TEXT,
						type TEXT NOT NULL CHECK(type IN ('once','daily','weekly','monthly')),
						config_json TEXT NOT NULL,
						time TEXT,
						active INTEGER NOT NULL DEFAULT 1 CHECK(active IN (0,1)),
						start_date TEXT,
						end_date TEXT,
						created_at TEXT NOT NULL,
						updated_at TEXT NOT NULL
					);
				''');

				await db.execute('''
					CREATE TABLE IF NOT EXISTS task_logs (
						id INTEGER PRIMARY KEY AUTOINCREMENT,
						task_id INTEGER NOT NULL,
						date TEXT NOT NULL,
						status TEXT NOT NULL CHECK(status IN ('completed','skipped')),
						completed_at TEXT,
						created_at TEXT NOT NULL,
						FOREIGN KEY(task_id) REFERENCES tasks(id) ON DELETE CASCADE,
						UNIQUE(task_id, date)
					);
				''');

				await db.execute('''
					CREATE INDEX IF NOT EXISTS idx_tasks_active
					ON tasks(active);
				''');

				await db.execute('''
					CREATE INDEX IF NOT EXISTS idx_task_logs_task_date
					ON task_logs(task_id, date);
				''');

				await db.execute('''
					CREATE INDEX IF NOT EXISTS idx_task_logs_date
					ON task_logs(date);
				''');
				break;
			default:
				developer.log(
					'No migration registered for version $version',
					name: 'AppMigrations',
				);
		}
	}
}
