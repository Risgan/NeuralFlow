"use client";

import React, { useState } from "react";
import { useTaskContext } from "@/context/task-context";
import {
  Task,
  Frequency,
  WEEKDAYS,
  WEEKDAYS_FULL,
  NTH_LABELS,
} from "@/lib/task-store";
import { X, Plus } from "lucide-react";

type Mode = "create" | "edit";

interface TaskModalProps {
  mode: Mode;
  task?: Task;
  onClose: () => void;
}

const defaultFrequency: Frequency = { type: "daily" };

export function TaskModal({ mode, task, onClose }: TaskModalProps) {
  const { addTask, updateTask } = useTaskContext();

  const [title, setTitle] = useState(task?.title ?? "");
  const [time, setTime] = useState(task?.time ?? "");
  const [frequency, setFrequency] = useState<Frequency>(
    task?.frequency ?? defaultFrequency
  );

  const freqType = frequency.type;

  function setFreqType(t: Frequency["type"]) {
    if (t === "once")
      setFrequency({ type: "once", date: new Date().toISOString().slice(0, 10) });
    else if (t === "daily") setFrequency({ type: "daily" });
    else if (t === "weekly") setFrequency({ type: "weekly", days: [1] });
    else if (t === "monthly")
      setFrequency({ type: "monthly", mode: "dayOfMonth", day: 1 });
  }

  function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    if (!title.trim()) return;
    const payload = {
      title: title.trim(),
      time: time || undefined,
      frequency,
      enabled: task?.enabled ?? true,
    };
    if (mode === "create") addTask(payload);
    else if (task) updateTask(task.id, payload);
    onClose();
  }

  return (
    <div
      className="fixed inset-0 z-50 flex items-end sm:items-center justify-center p-4"
      onClick={(e) => e.target === e.currentTarget && onClose()}
      role="dialog"
      aria-modal="true"
      aria-label={mode === "create" ? "Nueva tarea" : "Editar tarea"}
    >
      {/* Backdrop */}
      <div className="absolute inset-0 bg-foreground/20 backdrop-blur-sm" />

      <form
        onSubmit={handleSubmit}
        className="relative z-10 w-full max-w-md bg-card text-card-foreground rounded-2xl shadow-2xl p-6 flex flex-col gap-5"
        onClick={(e) => e.stopPropagation()}
      >
        {/* Header */}
        <div className="flex items-center justify-between">
          <h2 className="text-lg font-semibold">
            {mode === "create" ? "Nueva tarea" : "Editar tarea"}
          </h2>
          <button
            type="button"
            onClick={onClose}
            className="p-1.5 rounded-lg hover:bg-muted transition-colors text-muted-foreground hover:text-foreground"
            aria-label="Cerrar"
          >
            <X size={18} />
          </button>
        </div>

        {/* Title */}
        <div className="flex flex-col gap-1.5">
          <label className="text-sm font-medium text-muted-foreground" htmlFor="task-title">
            Título
          </label>
          <input
            id="task-title"
            type="text"
            value={title}
            onChange={(e) => setTitle(e.target.value)}
            placeholder="¿Qué necesitas hacer?"
            required
            className="w-full px-3 py-2.5 rounded-xl border border-border bg-background text-foreground placeholder:text-muted-foreground text-sm focus:outline-none focus:ring-2 focus:ring-ring transition"
          />
        </div>

        {/* Time */}
        <div className="flex flex-col gap-1.5">
          <label className="text-sm font-medium text-muted-foreground" htmlFor="task-time">
            Hora <span className="text-muted-foreground/60 font-normal">(opcional)</span>
          </label>
          <input
            id="task-time"
            type="time"
            value={time}
            onChange={(e) => setTime(e.target.value)}
            className="w-full px-3 py-2.5 rounded-xl border border-border bg-background text-foreground text-sm focus:outline-none focus:ring-2 focus:ring-ring transition"
          />
        </div>

        {/* Frequency selector */}
        <div className="flex flex-col gap-2">
          <span className="text-sm font-medium text-muted-foreground">Frecuencia</span>
          <div className="flex flex-wrap gap-2">
            {(["once", "daily", "weekly", "monthly"] as const).map((t) => (
              <button
                key={t}
                type="button"
                onClick={() => setFreqType(t)}
                className={`px-3 py-1.5 rounded-lg text-sm font-medium transition-colors ${
                  freqType === t
                    ? "bg-primary text-primary-foreground"
                    : "bg-secondary text-secondary-foreground hover:bg-accent"
                }`}
              >
                {t === "once" ? "Única" : t === "daily" ? "Diaria" : t === "weekly" ? "Semanal" : "Mensual"}
              </button>
            ))}
          </div>

          {/* Once: date picker */}
          {frequency.type === "once" && (
            <input
              type="date"
              value={frequency.date}
              onChange={(e) =>
                setFrequency({ type: "once", date: e.target.value })
              }
              className="px-3 py-2.5 rounded-xl border border-border bg-background text-foreground text-sm focus:outline-none focus:ring-2 focus:ring-ring transition"
            />
          )}

          {/* Weekly: day picker */}
          {frequency.type === "weekly" && (
            <div className="flex flex-wrap gap-1.5 mt-1">
              {WEEKDAYS.map((d, i) => (
                <button
                  key={i}
                  type="button"
                  onClick={() => {
                    if (frequency.type !== "weekly") return;
                    const days = frequency.days.includes(i)
                      ? frequency.days.filter((x) => x !== i)
                      : [...frequency.days, i].sort();
                    if (days.length > 0)
                      setFrequency({ type: "weekly", days });
                  }}
                  className={`w-9 h-9 rounded-full text-xs font-semibold transition-colors ${
                    frequency.type === "weekly" && frequency.days.includes(i)
                      ? "bg-primary text-primary-foreground"
                      : "bg-secondary text-secondary-foreground hover:bg-accent"
                  }`}
                >
                  {d}
                </button>
              ))}
            </div>
          )}

          {/* Monthly */}
          {frequency.type === "monthly" && (
            <div className="flex flex-col gap-2 mt-1">
              {/* Sub-mode */}
              <div className="flex gap-2">
                <button
                  type="button"
                  onClick={() =>
                    setFrequency({ type: "monthly", mode: "dayOfMonth", day: 1 })
                  }
                  className={`flex-1 py-1.5 rounded-lg text-sm font-medium transition-colors ${
                    frequency.mode === "dayOfMonth"
                      ? "bg-primary text-primary-foreground"
                      : "bg-secondary text-secondary-foreground hover:bg-accent"
                  }`}
                >
                  Día del mes
                </button>
                <button
                  type="button"
                  onClick={() =>
                    setFrequency({
                      type: "monthly",
                      mode: "pattern",
                      nth: 1,
                      weekday: 1,
                    })
                  }
                  className={`flex-1 py-1.5 rounded-lg text-sm font-medium transition-colors ${
                    frequency.mode === "pattern"
                      ? "bg-primary text-primary-foreground"
                      : "bg-secondary text-secondary-foreground hover:bg-accent"
                  }`}
                >
                  Patrón
                </button>
              </div>

              {frequency.mode === "dayOfMonth" && (
                <div className="flex items-center gap-2">
                  <span className="text-sm text-muted-foreground">Día:</span>
                  <input
                    type="number"
                    min={1}
                    max={31}
                    value={frequency.day}
                    onChange={(e) =>
                      setFrequency({
                        type: "monthly",
                        mode: "dayOfMonth",
                        day: Math.min(31, Math.max(1, Number(e.target.value))),
                      })
                    }
                    className="w-20 px-3 py-2 rounded-xl border border-border bg-background text-foreground text-sm focus:outline-none focus:ring-2 focus:ring-ring"
                  />
                </div>
              )}

              {frequency.mode === "pattern" && (
                <div className="flex flex-wrap items-center gap-2">
                  <select
                    value={frequency.nth}
                    onChange={(e) =>
                      setFrequency({
                        ...(frequency as { type: "monthly"; mode: "pattern"; nth: number; weekday: number }),
                        nth: Number(e.target.value),
                      })
                    }
                    className="px-3 py-2 rounded-xl border border-border bg-background text-foreground text-sm focus:outline-none focus:ring-2 focus:ring-ring"
                  >
                    {[1, 2, 3, 4, -1].map((n, i) => (
                      <option key={n} value={n}>
                        {n === -1 ? "Último" : NTH_LABELS[i].charAt(0).toUpperCase() + NTH_LABELS[i].slice(1)}
                      </option>
                    ))}
                  </select>
                  <select
                    value={frequency.weekday}
                    onChange={(e) =>
                      setFrequency({
                        ...(frequency as { type: "monthly"; mode: "pattern"; nth: number; weekday: number }),
                        weekday: Number(e.target.value),
                      })
                    }
                    className="px-3 py-2 rounded-xl border border-border bg-background text-foreground text-sm focus:outline-none focus:ring-2 focus:ring-ring"
                  >
                    {WEEKDAYS_FULL.map((d, i) => (
                      <option key={i} value={i}>
                        {d}
                      </option>
                    ))}
                  </select>
                </div>
              )}
            </div>
          )}
        </div>

        {/* Submit */}
        <button
          type="submit"
          className="w-full flex items-center justify-center gap-2 py-3 rounded-xl bg-primary text-primary-foreground font-semibold text-sm hover:opacity-90 transition-opacity"
        >
          <Plus size={16} />
          {mode === "create" ? "Crear tarea" : "Guardar cambios"}
        </button>
      </form>
    </div>
  );
}
