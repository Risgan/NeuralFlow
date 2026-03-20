"use client";

import React, { useState, useEffect } from "react";
import { useTaskContext } from "@/context/task-context";
import { todayStr } from "@/lib/task-store";
import { TaskItem } from "@/components/task-item";

export function TodayView() {
  const { todayTasks, isCompleted } = useTaskContext();
  const today = todayStr();
  const [formattedDate, setFormattedDate] = useState<string | null>(null);

  useEffect(() => {
    const dateLabel = new Date().toLocaleDateString("es-ES", {
      weekday: "long",
      day: "numeric",
      month: "long",
    });
    const [weekday, ...rest] = dateLabel.split(", ");
    setFormattedDate(
      `${weekday.charAt(0).toUpperCase() + weekday.slice(1)}, ${rest.join(", ")}`
    );
  }, []);

  const pending = todayTasks.filter((t) => !isCompleted(t.id, today));
  const done = todayTasks.filter((t) => isCompleted(t.id, today));

  // Sort by time (nulls last)
  const sortByTime = (arr: typeof todayTasks) =>
    [...arr].sort((a, b) => {
      if (!a.time && !b.time) return 0;
      if (!a.time) return 1;
      if (!b.time) return -1;
      return a.time.localeCompare(b.time);
    });

  const pendingSorted = sortByTime(pending);
  const doneSorted = sortByTime(done);

  return (
    <main className="flex-1 overflow-y-auto">
      <div className="max-w-lg mx-auto px-4 py-8 pb-28 flex flex-col gap-8">
        {/* Header */}
        <div className="flex flex-col items-center text-center">
          {formattedDate && (
            <p className="text-sm font-medium text-muted-foreground mb-3">
              {formattedDate}
            </p>
          )}
          <span
            className="text-9xl font-extrabold leading-none tracking-tight text-[var(--counter-text)]"
            aria-label={`${pending.length} tareas pendientes hoy`}
          >
            {pending.length}
          </span>
          <p className="mt-2 text-base font-medium text-muted-foreground">
            tarea{pending.length !== 1 ? "s" : ""} pendiente{pending.length !== 1 ? "s" : ""} hoy
          </p>
        </div>

        {/* Pending tasks */}
        {pendingSorted.length > 0 && (
          <section>
            <h2 className="sr-only">Tareas pendientes</h2>
            <div className="flex flex-col gap-2">
              {pendingSorted.map((task) => (
                <TaskItem key={task.id} task={task} date={today} />
              ))}
            </div>
          </section>
        )}

        {/* Empty state */}
        {todayTasks.length === 0 && (
          <div className="text-center py-12">
            <p className="text-muted-foreground text-sm">No hay tareas programadas para hoy.</p>
            <p className="text-muted-foreground/60 text-xs mt-1">Crea una nueva tarea con el botón +</p>
          </div>
        )}

        {/* Completed tasks */}
        {doneSorted.length > 0 && (
          <section>
            <h2 className="text-xs font-semibold uppercase tracking-widest text-muted-foreground/60 mb-3">
              Completadas · {doneSorted.length}
            </h2>
            <div className="flex flex-col gap-2">
              {doneSorted.map((task) => (
                <TaskItem key={task.id} task={task} date={today} />
              ))}
            </div>
          </section>
        )}
      </div>
    </main>
  );
}
