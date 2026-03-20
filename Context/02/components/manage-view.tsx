"use client";

import React, { useState } from "react";
import { useTaskContext } from "@/context/task-context";
import { formatFrequency } from "@/lib/task-store";
import { TaskModal } from "@/components/task-modal";
import { Task } from "@/lib/task-store";
import { Pencil, Trash2, Power, Clock, Repeat2, ListTodo } from "lucide-react";
import { cn } from "@/lib/utils";

export function ManageView() {
  const { tasks, deleteTask, toggleEnabled } = useTaskContext();
  const [editingTask, setEditingTask] = useState<Task | null>(null);
  const [deletingId, setDeletingId] = useState<string | null>(null);

  const active = tasks.filter((t) => t.enabled);
  const inactive = tasks.filter((t) => !t.enabled);

  function TaskRow({ task }: { task: Task }) {
    return (
      <div
        className={cn(
          "flex items-center gap-3 px-4 py-3.5 rounded-2xl border transition-all",
          task.enabled
            ? "border-border bg-card hover:border-primary/30"
            : "border-border/50 bg-muted/40 opacity-60"
        )}
      >
        <div className="flex-1 min-w-0">
          <p className={cn("text-sm font-medium truncate", !task.enabled && "text-muted-foreground")}>
            {task.title}
          </p>
          <div className="flex items-center gap-2 mt-0.5 flex-wrap">
            <div className="flex items-center gap-1">
              <Repeat2 size={11} className="text-muted-foreground/60" />
              <span className="text-xs text-muted-foreground/70">
                {formatFrequency(task.frequency)}
              </span>
            </div>
            {task.time && (
              <div className="flex items-center gap-1">
                <Clock size={11} className="text-muted-foreground/60" />
                <span className="text-xs text-muted-foreground/70">{task.time}</span>
              </div>
            )}
          </div>
        </div>

        <div className="flex items-center gap-1 flex-shrink-0">
          {/* Toggle enabled */}
          <button
            onClick={() => toggleEnabled(task.id)}
            className={cn(
              "p-2 rounded-xl transition-colors",
              task.enabled
                ? "text-primary hover:bg-primary/10"
                : "text-muted-foreground hover:bg-secondary"
            )}
            title={task.enabled ? "Desactivar" : "Activar"}
            aria-label={task.enabled ? "Desactivar tarea" : "Activar tarea"}
          >
            <Power size={15} />
          </button>

          {/* Edit */}
          <button
            onClick={() => setEditingTask(task)}
            className="p-2 rounded-xl text-muted-foreground hover:text-foreground hover:bg-secondary transition-colors"
            aria-label="Editar tarea"
          >
            <Pencil size={15} />
          </button>

          {/* Delete */}
          {deletingId === task.id ? (
            <div className="flex items-center gap-1">
              <button
                onClick={() => {
                  deleteTask(task.id);
                  setDeletingId(null);
                }}
                className="px-2.5 py-1.5 rounded-lg bg-destructive text-destructive-foreground text-xs font-semibold"
              >
                Sí
              </button>
              <button
                onClick={() => setDeletingId(null)}
                className="px-2.5 py-1.5 rounded-lg bg-secondary text-secondary-foreground text-xs font-semibold"
              >
                No
              </button>
            </div>
          ) : (
            <button
              onClick={() => setDeletingId(task.id)}
              className="p-2 rounded-xl text-muted-foreground hover:text-destructive hover:bg-destructive/10 transition-colors"
              aria-label="Eliminar tarea"
            >
              <Trash2 size={15} />
            </button>
          )}
        </div>
      </div>
    );
  }

  return (
    <main className="flex-1 overflow-y-auto">
      <div className="max-w-lg mx-auto px-4 py-8 pb-28 flex flex-col gap-6">
        <div>
          <h1 className="text-2xl font-bold text-foreground">Gestionar tareas</h1>
          <p className="text-sm text-muted-foreground mt-1">
            {tasks.length} tarea{tasks.length !== 1 ? "s" : ""} en total
          </p>
        </div>

        {tasks.length === 0 ? (
          <div className="flex flex-col items-center justify-center py-20 gap-3">
            <div className="w-12 h-12 rounded-2xl bg-secondary flex items-center justify-center">
              <ListTodo size={22} className="text-muted-foreground" />
            </div>
            <p className="text-sm text-muted-foreground text-center">
              No hay tareas creadas todavía.
            </p>
          </div>
        ) : (
          <div className="flex flex-col gap-6">
            {active.length > 0 && (
              <section>
                <h2 className="text-xs font-semibold uppercase tracking-widest text-muted-foreground/60 mb-3">
                  Activas · {active.length}
                </h2>
                <div className="flex flex-col gap-2">
                  {active.map((t) => (
                    <TaskRow key={t.id} task={t} />
                  ))}
                </div>
              </section>
            )}
            {inactive.length > 0 && (
              <section>
                <h2 className="text-xs font-semibold uppercase tracking-widest text-muted-foreground/60 mb-3">
                  Inactivas · {inactive.length}
                </h2>
                <div className="flex flex-col gap-2">
                  {inactive.map((t) => (
                    <TaskRow key={t.id} task={t} />
                  ))}
                </div>
              </section>
            )}
          </div>
        )}
      </div>

      {editingTask && (
        <TaskModal
          mode="edit"
          task={editingTask}
          onClose={() => setEditingTask(null)}
        />
      )}
    </main>
  );
}
