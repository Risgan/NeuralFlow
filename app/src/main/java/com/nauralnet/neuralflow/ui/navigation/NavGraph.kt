package com.nauralnet.neuralflow.ui.navigation

import androidx.compose.runtime.Composable
import androidx.navigation.NavHostController
import androidx.navigation.NavType
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import androidx.navigation.navArgument
import com.nauralnet.neuralflow.ui.screens.debug.DebugScreen
import com.nauralnet.neuralflow.ui.screens.history.TaskHistoryScreen
import com.nauralnet.neuralflow.ui.screens.home.HomeScreen
import com.nauralnet.neuralflow.ui.screens.settings.SettingsScreen
import com.nauralnet.neuralflow.ui.screens.task_detail.TaskDetailScreen
import com.nauralnet.neuralflow.ui.screens.task_form.TaskFormScreen

/**
 * Rutas de navegación de la aplicación
 */
sealed class Screen(val route: String) {
    object Home : Screen("home")
    object TaskForm : Screen("task_form?taskId={taskId}") {
        fun createRoute(taskId: Int? = null): String {
            return if (taskId != null) "task_form?taskId=$taskId" else "task_form"
        }
    }
    object TaskDetail : Screen("task_detail/{taskId}") {
        fun createRoute(taskId: Int): String = "task_detail/$taskId"
    }
    object History : Screen("history")
    object Settings : Screen("settings")
    object Debug : Screen("debug")
}

@Composable
fun NavGraph(
    navController: NavHostController = rememberNavController(),
    startDestination: String = Screen.Home.route
) {
    NavHost(
        navController = navController,
        startDestination = startDestination
    ) {
        // Home - Pantalla principal con lista de tareas del día
        composable(Screen.Home.route) {
            HomeScreen(
                onNavigateToTaskForm = { taskId ->
                    navController.navigate(Screen.TaskForm.createRoute(taskId))
                },
                onNavigateToTaskDetail = { taskId ->
                    navController.navigate(Screen.TaskDetail.createRoute(taskId))
                },
                onNavigateToHistory = {
                    navController.navigate(Screen.History.route)
                },
                onNavigateToSettings = {
                    navController.navigate(Screen.Settings.route)
                },
                onNavigateToDebug = {
                    navController.navigate(Screen.Debug.route)
                }
            )
        }

        // TaskForm - Crear o editar tarea
        composable(
            route = Screen.TaskForm.route,
            arguments = listOf(
                navArgument("taskId") {
                    type = NavType.StringType
                    nullable = true
                    defaultValue = null
                }
            )
        ) { backStackEntry ->
            val taskIdString = backStackEntry.arguments?.getString("taskId")
            val taskId = taskIdString?.toIntOrNull()

            TaskFormScreen(
                taskId = taskId,
                onNavigateBack = {
                    navController.popBackStack()
                }
            )
        }

        // TaskDetail - Detalles de una tarea específica
        composable(
            route = Screen.TaskDetail.route,
            arguments = listOf(
                navArgument("taskId") {
                    type = NavType.IntType
                }
            )
        ) { backStackEntry ->
            val taskId = backStackEntry.arguments?.getInt("taskId") ?: return@composable

            TaskDetailScreen(
                taskId = taskId,
                onNavigateBack = {
                    navController.popBackStack()
                },
                onNavigateToEdit = { id ->
                    navController.navigate(Screen.TaskForm.createRoute(id))
                }
            )
        }

        // History - Historial de tareas completadas
        composable(Screen.History.route) {
            TaskHistoryScreen(
                onNavigateBack = {
                    navController.popBackStack()
                },
                onNavigateToTaskDetail = { taskId ->
                    navController.navigate(Screen.TaskDetail.createRoute(taskId))
                }
            )
        }

        // Settings - Configuración de la aplicación
        composable(Screen.Settings.route) {
            SettingsScreen(
                onNavigateBack = {
                    navController.popBackStack()
                }
            )
        }

        // Debug - Pantalla de debug/desarrollo
        composable(Screen.Debug.route) {
            DebugScreen(
                onNavigateBack = {
                    navController.popBackStack()
                }
            )
        }
    }
}
