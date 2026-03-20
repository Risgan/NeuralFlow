"use client";

import React, { useMemo } from "react";
import { useTaskContext } from "@/context/task-context";
import { isScheduledOn } from "@/lib/task-store";
import { TaskItem } from "@/components/task-item";
import { Calendar } from "lucide-react";

/** Returns last N days as "YYYY-MM-DD" strings, most recent first */
function lastNDays(n: number): string[] {
  const days: string[] = [];
  for (let i = 0; i < n; i++) {
    const d = new Date();
    d.setDate(d.getDate() - i);
    days.push(d.toISOString().slice(0, 10));
  }
  return days;
}

function formatDateLabel(dateStr: string): string {
  const today = new Date().toISOString().slice(0, 10);
  const yesterday = new Date(Date.now() - 86400000).toISOString().slice(0, 10);
  if (dateStr === today) return "Hoy";
  if (dateStr === yesterday) return "Ayer";
  const d = new Date(dateStr + "T12:00:00");
  return d.toLocaleDateString("es-ES", {
    weekday: "long",
    day: "numeric",
    month: "long",
  });
}

export function HistoryView() {
  const { tasks, completions } = useTaskContext();
  const days = lastNDays(30);

  const historyData = useMemo(() => {
    return days
      .map((date) => {
        const completed = completions.filter((c) => c.date === date);
        const completedTasks = completed
          .map((c) => tasks.find((t) => t.id === c.taskId))
          .filter(Boolean) as typeof tasks;
        return { date, completedTasks };
      })
      .filter((d) => d.completedTasks.length > 0);
  }, [days, tasks, completions]);

  return (
    <main className="flex-1 overflow-y-auto">
      <div className="max-w-lg mx-auto px-4 py-8 pb-28 flex flex-col gap-6">
        <div>
          <h1 className="text-2xl font-bold text-foreground">Historial</h1>
          <p className="text-sm text-muted-foreground mt-1">
            Tareas completadas en los últimos 30 días
          </p>
        </div>

        {historyData.length === 0 ? (
          <div className="flex flex-col items-center justify-center py-20 gap-3">
            <div className="w-12 h-12 rounded-2xl bg-secondary flex items-center justify-center">
              <Calendar size={22} className="text-muted-foreground" />
            </div>
            <p className="text-sm text-muted-foreground text-center">
              Aún no hay tareas completadas.
            </p>
          </div>
        ) : (
          <div className="flex flex-col gap-6">
            {historyData.map(({ date, completedTasks }) => (
              <section key={date}>
                <div className="flex items-center gap-3 mb-2">
                  <h2 className="text-xs font-semibold uppercase tracking-widest text-muted-foreground/70">
                    {formatDateLabel(date)}
                  </h2>
                  <span className="flex-1 h-px bg-border" />
                  <span className="text-xs text-muted-foreground">
                    {completedTasks.length}
                  </span>
                </div>
                <div className="flex flex-col gap-2">
                  {completedTasks.map((task) => (
                    <TaskItem key={task.id} task={task} date={date} readOnly />
                  ))}
                </div>
              </section>
            ))}
          </div>
        )}
      </div>
    </main>
  );
}
