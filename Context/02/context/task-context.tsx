"use client";

import React, {
  createContext,
  useContext,
  useState,
  useCallback,
  useEffect,
} from "react";
import {
  Task,
  CompletionRecord,
  generateId,
  todayStr,
  isScheduledOn,
} from "@/lib/task-store";

// ─── Seed data ──────────────────────────────────────────────────────────────
const SEED_TASKS: Task[] = [
  {
    id: "t1",
    title: "Hacer ejercicio",
    time: "07:00",
    frequency: { type: "daily" },
    enabled: true,
    createdAt: "2026-01-01",
  },
  {
    id: "t2",
    title: "Revisar correos",
    time: "09:00",
    frequency: { type: "weekly", days: [1, 2, 3, 4, 5] },
    enabled: true,
    createdAt: "2026-01-01",
  },
  {
    id: "t3",
    title: "Meditación matutina",
    time: "06:30",
    frequency: { type: "daily" },
    enabled: true,
    createdAt: "2026-01-01",
  },
  {
    id: "t4",
    title: "Llamada con equipo",
    time: "10:00",
    frequency: { type: "weekly", days: [1, 3, 5] },
    enabled: true,
    createdAt: "2026-01-01",
  },
  {
    id: "t5",
    title: "Pagar facturas",
    frequency: { type: "monthly", mode: "dayOfMonth", day: 5 },
    enabled: true,
    createdAt: "2026-01-01",
  },
];

// ─── Context types ───────────────────────────────────────────────────────────
interface TaskContextValue {
  tasks: Task[];
  completions: CompletionRecord[];
  addTask: (t: Omit<Task, "id" | "createdAt">) => void;
  updateTask: (id: string, t: Partial<Omit<Task, "id" | "createdAt">>) => void;
  deleteTask: (id: string) => void;
  toggleEnabled: (id: string) => void;
  toggleComplete: (taskId: string, date: string) => void;
  isCompleted: (taskId: string, date: string) => boolean;
  todayTasks: Task[];
  pendingCount: number;
  darkMode: boolean;
  toggleDarkMode: () => void;
}

const TaskContext = createContext<TaskContextValue | null>(null);

export function TaskProvider({ children }: { children: React.ReactNode }) {
  const [tasks, setTasks] = useState<Task[]>(SEED_TASKS);
  const [completions, setCompletions] = useState<CompletionRecord[]>([]);
  const [darkMode, setDarkMode] = useState(false);

  // Apply dark mode class to <html>
  useEffect(() => {
    document.documentElement.classList.toggle("dark", darkMode);
  }, [darkMode]);

  const addTask = useCallback((t: Omit<Task, "id" | "createdAt">) => {
    const newTask: Task = { ...t, id: generateId(), createdAt: todayStr() };
    setTasks((prev) => [...prev, newTask]);
  }, []);

  const updateTask = useCallback(
    (id: string, changes: Partial<Omit<Task, "id" | "createdAt">>) => {
      setTasks((prev) =>
        prev.map((t) => (t.id === id ? { ...t, ...changes } : t))
      );
    },
    []
  );

  const deleteTask = useCallback((id: string) => {
    setTasks((prev) => prev.filter((t) => t.id !== id));
    setCompletions((prev) => prev.filter((c) => c.taskId !== id));
  }, []);

  const toggleEnabled = useCallback((id: string) => {
    setTasks((prev) =>
      prev.map((t) => (t.id === id ? { ...t, enabled: !t.enabled } : t))
    );
  }, []);

  const isCompleted = useCallback(
    (taskId: string, date: string) =>
      completions.some((c) => c.taskId === taskId && c.date === date),
    [completions]
  );

  const toggleComplete = useCallback((taskId: string, date: string) => {
    setCompletions((prev) => {
      const exists = prev.some((c) => c.taskId === taskId && c.date === date);
      if (exists) {
        return prev.filter((c) => !(c.taskId === taskId && c.date === date));
      }
      return [
        ...prev,
        { taskId, date, completedAt: new Date().toISOString() },
      ];
    });
  }, []);

  const today = todayStr();
  const todayTasks = tasks.filter((t) => isScheduledOn(t, today));
  const pendingCount = todayTasks.filter((t) => !isCompleted(t.id, today)).length;

  const toggleDarkMode = useCallback(() => setDarkMode((d) => !d), []);

  return (
    <TaskContext.Provider
      value={{
        tasks,
        completions,
        addTask,
        updateTask,
        deleteTask,
        toggleEnabled,
        toggleComplete,
        isCompleted,
        todayTasks,
        pendingCount,
        darkMode,
        toggleDarkMode,
      }}
    >
      {children}
    </TaskContext.Provider>
  );
}

export function useTaskContext() {
  const ctx = useContext(TaskContext);
  if (!ctx) throw new Error("useTaskContext must be inside TaskProvider");
  return ctx;
}
