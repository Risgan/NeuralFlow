"use client";

import React from "react";
import { Check, Clock } from "lucide-react";
import { Task } from "@/lib/task-store";
import { useTaskContext } from "@/context/task-context";
import { todayStr } from "@/lib/task-store";
import { cn } from "@/lib/utils";

interface TaskItemProps {
  task: Task;
  date?: string;
  readOnly?: boolean;
}

export function TaskItem({ task, date, readOnly = false }: TaskItemProps) {
  const { toggleComplete, isCompleted } = useTaskContext();
  const d = date ?? todayStr();
  const done = isCompleted(task.id, d);

  return (
    <div
      className={cn(
        "flex items-center gap-3 px-4 py-3.5 rounded-2xl border transition-all",
        done
          ? "border-border/50 bg-[var(--task-done-bg)] opacity-60"
          : "border-border bg-[var(--task-pending-bg)] hover:border-primary/30 hover:shadow-sm"
      )}
    >
      {/* Checkbox */}
      {!readOnly ? (
        <button
          onClick={() => toggleComplete(task.id, d)}
          className={cn(
            "flex-shrink-0 w-5 h-5 rounded-full border-2 flex items-center justify-center transition-all",
            done
              ? "bg-primary border-primary"
              : "border-muted-foreground/40 hover:border-primary"
          )}
          aria-label={done ? "Marcar como pendiente" : "Marcar como completada"}
          aria-checked={done}
          role="checkbox"
        >
          {done && <Check size={11} strokeWidth={3} className="text-primary-foreground" />}
        </button>
      ) : (
        <div className="flex-shrink-0 w-5 h-5 rounded-full border-2 border-primary/60 bg-primary/10 flex items-center justify-center">
          <Check size={11} strokeWidth={3} className="text-primary" />
        </div>
      )}

      {/* Content */}
      <div className="flex-1 min-w-0">
        <p
          className={cn(
            "text-sm font-medium leading-snug truncate",
            done
              ? "line-through text-[var(--task-done-text)]"
              : "text-foreground"
          )}
        >
          {task.title}
        </p>
      </div>

      {/* Time */}
      {task.time && (
        <div className="flex items-center gap-1 flex-shrink-0">
          <Clock size={12} className="text-muted-foreground" />
          <span className="text-xs text-muted-foreground font-medium">
            {task.time}
          </span>
        </div>
      )}
    </div>
  );
}
