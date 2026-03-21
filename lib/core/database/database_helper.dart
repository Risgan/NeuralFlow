import 'dart:developer' as developer;

import 'package:neural_flow/core/database/migrations.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
	DatabaseHelper._();

	static final DatabaseHelper instance = DatabaseHelper._();
	static const String _databaseName = 'neural_flow.db';

	Database? _database;

	Future<Database> get database async {
		if (_database != null) return _database!;
		_database = await _openDatabase();
		return _database!;
	}

	Future<void> init() async {
		await database;
	}

	Future<Database> _openDatabase() async {
		final dbPath = await getDatabasesPath();
		final fullPath = p.join(dbPath, _databaseName);

		developer.log('Opening DB at $fullPath', name: 'DatabaseHelper');

		return openDatabase(
			fullPath,
			version: AppMigrations.currentVersion,
			onConfigure: (db) async {
				await db.execute('PRAGMA foreign_keys = ON;');
			},
			onCreate: AppMigrations.onCreate,
			onUpgrade: AppMigrations.onUpgrade,
		);
	}

	Future<void> close() async {
		if (_database == null) return;
		await _database!.close();
		_database = null;
	}

	Future<void> deleteDatabaseFile() async {
		final dbPath = await getDatabasesPath();
		final fullPath = p.join(dbPath, _databaseName);

		await close();
		await deleteDatabase(fullPath);
		developer.log('DB deleted at $fullPath', name: 'DatabaseHelper');
	}
}
