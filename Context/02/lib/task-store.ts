// Task data types and helpers — purely in-memory (no localStorage by design)
export type Frequency =
  | { type: "once"; date: string }
  | { type: "daily" }
  | { type: "weekly"; days: number[] } // 0=Sun … 6=Sat
  | { type: "monthly"; mode: "dayOfMonth"; day: number }
  | { type: "monthly"; mode: "pattern"; nth: number; weekday: number }; // nth=-1 means last

export interface Task {
  id: string;
  title: string;
  time?: string; // "HH:MM"
  frequency: Frequency;
  enabled: boolean;
  createdAt: string; // ISO date
}

export interface CompletionRecord {
  taskId: string;
  date: string; // "YYYY-MM-DD"
  completedAt: string; // ISO datetime
}

export const WEEKDAYS = ["Dom", "Lun", "Mar", "Mié", "Jue", "Vie", "Sáb"];
export const WEEKDAYS_FULL = ["Domingo", "Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado"];
export const NTH_LABELS = ["primer", "segundo", "tercer", "cuarto", "último"];

export function todayStr(): string {
  return new Date().toISOString().slice(0, 10);
}

/** Checks if a task is scheduled on a specific date string "YYYY-MM-DD" */
export function isScheduledOn(task: Task, dateStr: string): boolean {
  if (!task.enabled) return false;
  const date = new Date(dateStr + "T12:00:00");
  const f = task.frequency;

  if (f.type === "once") return f.date === dateStr;
  if (f.type === "daily") return true;
  if (f.type === "weekly") return f.days.includes(date.getDay());
  if (f.type === "monthly") {
    if (f.mode === "dayOfMonth") return date.getDate() === f.day;
    if (f.mode === "pattern") {
      const weekday = date.getDay();
      if (weekday !== f.weekday) return false;
      if (f.nth === -1) {
        // last occurrence: next 7 days would be next month
        const next = new Date(date);
        next.setDate(date.getDate() + 7);
        return next.getMonth() !== date.getMonth();
      }
      // nth occurrence (1-indexed)
      let count = 0;
      const d = new Date(date.getFullYear(), date.getMonth(), 1);
      while (d.getMonth() === date.getMonth()) {
        if (d.getDay() === weekday) count++;
        if (d.getDate() === date.getDate()) return count === f.nth;
        d.setDate(d.getDate() + 1);
      }
      return false;
    }
  }
  return false;
}

export function generateId(): string {
  return Math.random().toString(36).slice(2, 10);
}

export function formatFrequency(f: Frequency): string {
  if (f.type === "once") return `Una vez (${f.date})`;
  if (f.type === "daily") return "Diaria";
  if (f.type === "weekly") {
    if (f.days.length === 7) return "Todos los días";
    return "Semanal: " + f.days.map((d) => WEEKDAYS[d]).join(", ");
  }
  if (f.type === "monthly") {
    if (f.mode === "dayOfMonth") return `Mensual: día ${f.day}`;
    const nth = f.nth === -1 ? "último" : NTH_LABELS[f.nth - 1];
    return `Mensual: ${nth} ${WEEKDAYS_FULL[f.weekday]}`;
  }
  return "";
}
