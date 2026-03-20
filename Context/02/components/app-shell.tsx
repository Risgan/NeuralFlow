"use client";

import React, { useState } from "react";
import { useTaskContext } from "@/context/task-context";
import { TodayView } from "@/components/today-view";
import { HistoryView } from "@/components/history-view";
import { ManageView } from "@/components/manage-view";
import { TaskModal } from "@/components/task-modal";
import { Sun, Moon, CalendarDays, ListTodo, Plus, CheckSquare } from "lucide-react";
import { cn } from "@/lib/utils";

type Tab = "today" | "history" | "manage";

export function AppShell() {
  const { pendingCount, darkMode, toggleDarkMode } = useTaskContext();
  const [tab, setTab] = useState<Tab>("today");
  const [showModal, setShowModal] = useState(false);

  const tabs: { id: Tab; label: string; icon: React.ReactNode }[] = [
    { id: "today", label: "Hoy", icon: <CheckSquare size={20} /> },
    { id: "history", label: "Historial", icon: <CalendarDays size={20} /> },
    { id: "manage", label: "Tareas", icon: <ListTodo size={20} /> },
  ];

  return (
    <div className="flex flex-col h-screen bg-background">
      {/* Top header */}
      <header className="flex items-center justify-between px-4 pt-5 pb-3 max-w-lg mx-auto w-full">
        <div>
          <h1 className="text-xl font-bold text-foreground tracking-tight">Neural Flow</h1>
          {tab === "today" && (
            <p className="text-xs text-muted-foreground">
              {pendingCount > 0
                ? `${pendingCount} pendiente${pendingCount !== 1 ? "s" : ""}`
                : "Todo al día"}
            </p>
          )}
        </div>
        <button
          onClick={toggleDarkMode}
          className="p-2.5 rounded-xl bg-secondary text-secondary-foreground hover:bg-accent transition-colors"
          aria-label={darkMode ? "Cambiar a modo claro" : "Cambiar a modo oscuro"}
        >
          {darkMode ? <Sun size={17} /> : <Moon size={17} />}
        </button>
      </header>

      {/* View content */}
      {tab === "today" && <TodayView />}
      {tab === "history" && <HistoryView />}
      {tab === "manage" && <ManageView />}

      {/* Bottom nav */}
      <nav
        className="fixed bottom-0 left-0 right-0 z-40"
        aria-label="Navegación principal"
      >
        <div className="max-w-lg mx-auto">
          <div className="mx-3 mb-3 flex items-center justify-around bg-card border border-border rounded-2xl shadow-lg px-1 py-1.5">
            {tabs.map((t) => (
              <button
                key={t.id}
                onClick={() => setTab(t.id)}
                className={cn(
                  "flex-1 flex flex-col items-center gap-0.5 py-1.5 rounded-xl transition-all text-xs font-medium",
                  tab === t.id
                    ? "text-primary bg-primary/8"
                    : "text-muted-foreground hover:text-foreground hover:bg-secondary/60"
                )}
                aria-label={t.label}
                aria-current={tab === t.id ? "page" : undefined}
              >
                {t.icon}
                <span>{t.label}</span>
              </button>
            ))}
          </div>
        </div>
      </nav>

      {/* FAB */}
      <button
        onClick={() => setShowModal(true)}
        className="fixed bottom-24 right-4 sm:right-[calc(50%-220px)] z-40 w-14 h-14 rounded-full bg-primary text-primary-foreground shadow-lg flex items-center justify-center hover:scale-105 hover:shadow-xl transition-all active:scale-95"
        aria-label="Crear nueva tarea"
      >
        <Plus size={24} strokeWidth={2.5} />
      </button>

      {/* New task modal */}
      {showModal && (
        <TaskModal mode="create" onClose={() => setShowModal(false)} />
      )}
    </div>
  );
}
