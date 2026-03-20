/**
 * @license
 * SPDX-License-Identifier: Apache-2.0
 */

import React, { useState, useEffect } from 'react';
import { motion, AnimatePresence } from 'motion/react';
import { 
  Plus, 
  History, 
  Calendar, 
  Check, 
  X, 
  ChevronLeft,
  MoreVertical,
  Trash2,
  Edit2,
  Power,
  Sun,
  Moon
} from 'lucide-react';
import { Task, FrequencyType, WeekDay, MonthlyMode } from './types';
import { MOCK_TASKS } from './mockData';

type View = 'home' | 'create' | 'scheduled' | 'history';

export default function App() {
  const [view, setView] = useState<View>('home');
  const [tasks, setTasks] = useState<Task[]>(MOCK_TASKS);
  const [editingTask, setEditingTask] = useState<Task | null>(null);
  const [isDarkMode, setIsDarkMode] = useState(true);

  useEffect(() => {
    if (isDarkMode) {
      document.documentElement.classList.add('dark');
    } else {
      document.documentElement.classList.remove('dark');
    }
  }, [isDarkMode]);

  // Home Screen State
  const pendingTasks = tasks.filter(t => !t.completed && t.active);
  const completedToday = tasks.filter(t => t.completed && t.active);

  const toggleTask = (id: string) => {
    setTasks(prev => prev.map(t => 
      t.id === id ? { ...t, completed: !t.completed, completedAt: !t.completed ? Date.now() : undefined } : t
    ));
  };

  const deleteTask = (id: string) => {
    setTasks(prev => prev.filter(t => t.id !== id));
  };

  const toggleActive = (id: string) => {
    setTasks(prev => prev.map(t => 
      t.id === id ? { ...t, active: !t.active } : t
    ));
  };

  const addTask = (task: Omit<Task, 'id' | 'createdAt' | 'completed'>) => {
    const newTask: Task = {
      ...task,
      id: Math.random().toString(36).substr(2, 9),
      createdAt: Date.now(),
      completed: false,
    };
    setTasks(prev => [newTask, ...prev]);
    setView('home');
  };

  const updateTask = (id: string, updates: Partial<Task>) => {
    setTasks(prev => prev.map(t => t.id === id ? { ...t, ...updates } : t));
    setEditingTask(null);
    setView('home');
  };

  return (
    <div className="min-h-screen bg-background text-ink selection:bg-primary/30 max-w-md mx-auto relative overflow-hidden flex flex-col shadow-2xl">
      <AnimatePresence mode="wait">
        {view === 'home' && (
          <HomeView 
            key="home"
            pendingTasks={pendingTasks}
            completedCount={completedToday.length}
            onToggle={toggleTask}
            onNavigate={setView}
            isDarkMode={isDarkMode}
            onToggleTheme={() => setIsDarkMode(!isDarkMode)}
            onEdit={(task) => {
              setEditingTask(task);
              setView('create');
            }}
            onDelete={deleteTask}
          />
        )}
        {view === 'create' && (
          <CreateTaskView 
            key="create"
            onBack={() => {
              setView('home');
              setEditingTask(null);
            }}
            onSubmit={editingTask ? (updates) => updateTask(editingTask.id, updates) : addTask}
            initialData={editingTask}
          />
        )}
        {view === 'scheduled' && (
          <ScheduledView 
            key="scheduled"
            tasks={tasks}
            onBack={() => setView('home')}
            onToggleActive={toggleActive}
            onDelete={deleteTask}
            onEdit={(task) => {
              setEditingTask(task);
              setView('create');
            }}
          />
        )}
        {view === 'history' && (
          <HistoryView 
            key="history"
            tasks={tasks.filter(t => t.completed)}
            onBack={() => setView('home')}
          />
        )}
      </AnimatePresence>

      {/* Floating Action Button */}
      {view === 'home' && (
        <motion.button
          initial={{ scale: 0, opacity: 0, y: 20 }}
          animate={{ scale: 1, opacity: 1, y: 0 }}
          whileHover={{ scale: 1.1 }}
          whileTap={{ scale: 0.9 }}
          onClick={() => setView('create')}
          className="fixed bottom-10 right-10 w-16 h-16 bg-primary rounded-[24px] flex items-center justify-center shadow-2xl shadow-primary/40 z-50 hover:brightness-110 transition-all"
        >
          <Plus className="text-background w-10 h-10" />
        </motion.button>
      )}
    </div>
  );
}

// --- VIEWS ---

function HomeView({ 
  pendingTasks, 
  completedCount, 
  onToggle, 
  onNavigate,
  isDarkMode,
  onToggleTheme,
  onEdit,
  onDelete
}: { 
  pendingTasks: Task[], 
  completedCount: number, 
  onToggle: (id: string) => void,
  onNavigate: (view: View) => void,
  isDarkMode: boolean,
  onToggleTheme: () => void,
  onEdit: (task: Task) => void,
  onDelete: (id: string) => void,
  key?: string
}) {
  return (
    <motion.div 
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      exit={{ opacity: 0, y: -20 }}
      className="flex-1 flex flex-col p-6"
    >
      {/* Header */}
      <div className="flex justify-between items-center mb-10 sticky top-0 z-40 bg-background/80 backdrop-blur-md py-4 -mx-6 px-6">
        <div className="flex gap-1">
          <button onClick={() => onNavigate('history')} className="p-2.5 hover:bg-primary/10 rounded-xl transition-all active:scale-90">
            <History className="w-5 h-5 text-primary" />
          </button>
          <button onClick={() => onNavigate('scheduled')} className="p-2.5 hover:bg-primary/10 rounded-xl transition-all active:scale-90">
            <Calendar className="w-5 h-5 text-primary" />
          </button>
        </div>
        
        <button 
          onClick={onToggleTheme} 
          className="p-2.5 bg-primary-container text-on-primary-container rounded-xl shadow-premium hover:scale-105 transition-all active:scale-90"
        >
          {isDarkMode ? <Sun className="w-5 h-5" /> : <Moon className="w-5 h-5" />}
        </button>
      </div>

      {/* Summary */}
      <div className="text-center mb-10 relative py-8">
        <div className="absolute inset-0 bg-primary/10 blur-[100px] rounded-full -z-10" />
        <motion.div
          key={pendingTasks.length}
          initial={{ y: 20, opacity: 0 }}
          animate={{ y: 0, opacity: 1 }}
          className="relative inline-block"
        >
          <h1 className="text-[120px] font-thin text-primary leading-none tracking-tighter">
            {pendingTasks.length}
          </h1>
          <div className="absolute -top-2 -right-4 w-4 h-4 bg-primary rounded-full animate-pulse shadow-lg shadow-primary/50" />
        </motion.div>
        <p className="text-ink/40 uppercase tracking-[0.4em] text-[10px] font-black mt-2">tareas pendientes</p>
        
        <div className="flex items-center justify-center gap-3 mt-6 bg-success/10 w-fit mx-auto px-4 py-1.5 rounded-full border border-success/20">
          <div className="w-1.5 h-1.5 rounded-full bg-success animate-pulse" />
          <p className="text-success text-[11px] font-bold uppercase tracking-wider">{completedCount} completadas hoy</p>
        </div>
      </div>

      {/* Task List */}
      <div className="flex-1 overflow-y-auto no-scrollbar space-y-4">
        {pendingTasks.length === 0 ? (
          <div className="text-center py-12 opacity-20">
            <Check className="w-12 h-12 mx-auto mb-2" />
            <p>Todo listo por hoy</p>
          </div>
        ) : (
          pendingTasks.map(task => (
            <TaskItem 
              key={task.id} 
              task={task} 
              onToggle={() => onToggle(task.id)} 
              onEdit={() => onEdit(task)}
              onDelete={() => onDelete(task.id)}
            />
          ))
        )}
      </div>
    </motion.div>
  );
}

function TaskItem({ 
  task, 
  onToggle, 
  onEdit, 
  onDelete 
}: { 
  task: Task, 
  onToggle: () => void,
  onEdit: () => void,
  onDelete: () => void,
  key?: string
}) {
  const [isSwiped, setIsSwiped] = useState(false);
  const [touchStart, setTouchStart] = useState(0);

  const handleTouchStart = (e: React.TouchEvent) => setTouchStart(e.targetTouches[0].clientX);
  const handleTouchMove = (e: React.TouchEvent) => {
    const diff = touchStart - e.targetTouches[0].clientX;
    if (diff > 50) setIsSwiped(true);
    if (diff < -50) setIsSwiped(false);
  };

  return (
    <div className="relative group overflow-hidden rounded-2xl">
      {/* Delete Action (Swipe) */}
      <div className="absolute inset-0 bg-rose-500/20 flex items-center justify-end px-6">
        <Trash2 className="text-rose-500 w-6 h-6" />
      </div>

      <motion.div
        animate={{ x: isSwiped ? -80 : 0 }}
        onTouchStart={handleTouchStart}
        onTouchMove={handleTouchMove}
        onContextMenu={(e) => {
          e.preventDefault();
          onEdit();
        }}
        className="relative bg-surface p-5 flex items-center gap-5 cursor-pointer hover:bg-primary/[0.02] transition-all border border-ink/[0.03] shadow-premium rounded-2xl"
        onClick={onToggle}
      >
        <div className={`w-8 h-8 rounded-xl border-2 flex items-center justify-center transition-all duration-500 ${
          task.completed ? 'bg-success border-success rotate-[360deg] scale-90' : 'border-primary/20 bg-primary/5'
        }`}>
          {task.completed && <Check className="w-5 h-5 text-background stroke-[3]" />}
        </div>
        <div className="flex-1">
          <p className={`text-[17px] font-semibold tracking-tight transition-all duration-500 ${task.completed ? 'opacity-20 line-through scale-95 origin-left' : 'text-ink'}`}>
            {task.title}
          </p>
          {task.time && (
            <div className="flex items-center gap-2 mt-1.5">
              <div className="w-1 h-1 rounded-full bg-primary" />
              <p className="text-[10px] text-primary font-black uppercase tracking-[0.15em]">{task.time}</p>
            </div>
          )}
        </div>
      </motion.div>

      {isSwiped && (
        <button 
          onClick={(e) => {
            e.stopPropagation();
            onDelete();
          }}
          className="absolute right-0 top-0 bottom-0 w-20 flex items-center justify-center z-10"
        />
      )}
    </div>
  );
}

function CreateTaskView({ 
  onBack, 
  onSubmit,
  initialData 
}: { 
  onBack: () => void, 
  onSubmit: (task: Partial<Task>) => void,
  initialData?: Task | null,
  key?: string
}) {
  const [title, setTitle] = useState(initialData?.title || '');
  const [frequency, setFrequency] = useState<FrequencyType>(initialData?.frequency || 'unique');
  const [time, setTime] = useState(initialData?.time || '');
  const [date, setDate] = useState(initialData?.date || '');
  const [weekDays, setWeekDays] = useState<WeekDay[]>(initialData?.weekDays || []);
  const [monthlyMode, setMonthlyMode] = useState<MonthlyMode>(initialData?.monthlyMode || 'specific_day');
  const [monthlyDay, setMonthlyDay] = useState(initialData?.monthlyDay || 1);
  const [monthlyWeeks, setMonthlyWeeks] = useState<number[]>(initialData?.monthlyWeeks || [1]);
  const [monthlyDayOfWeek, setMonthlyDayOfWeek] = useState<WeekDay>(initialData?.monthlyDayOfWeek || 'L');

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!title) return;
    onSubmit({
      title,
      frequency,
      time,
      date,
      weekDays,
      monthlyMode,
      monthlyDay,
      monthlyWeeks,
      monthlyDayOfWeek,
      active: true
    });
  };

  const toggleDay = (day: WeekDay) => {
    setWeekDays(prev => prev.includes(day) ? prev.filter(d => d !== day) : [...prev, day]);
  };

  const toggleWeek = (w: number) => {
    setMonthlyWeeks(prev => prev.includes(w) ? prev.filter(x => x !== w) : [...prev, w]);
  };

  return (
    <motion.div 
      initial={{ x: '100%' }}
      animate={{ x: 0 }}
      exit={{ x: '100%' }}
      transition={{ type: 'spring', damping: 25, stiffness: 200 }}
      className="flex-1 flex flex-col bg-background p-6 z-50"
    >
      <div className="flex items-center gap-4 mb-10">
        <button onClick={onBack} className="p-3 -ml-3 hover:bg-primary/10 rounded-2xl transition-all active:scale-90">
          <ChevronLeft className="w-6 h-6 text-primary" />
        </button>
        <h2 className="text-2xl font-bold tracking-tight">{initialData ? 'Editar tarea' : 'Nueva tarea'}</h2>
      </div>

      <form onSubmit={handleSubmit} className="flex-1 flex flex-col gap-10">
        <div className="space-y-3">
          <label className="text-[10px] text-primary uppercase tracking-[0.3em] font-black ml-1">Título de la tarea</label>
          <input 
            autoFocus
            type="text" 
            value={title}
            onChange={e => setTitle(e.target.value)}
            placeholder="Ej: Barrer la sala"
            className="w-full bg-transparent text-4xl font-thin border-b-2 border-primary/10 pb-4 focus:outline-none focus:border-primary transition-all placeholder:text-ink/10"
            required
          />
        </div>

        <div className="space-y-5">
          <label className="text-[10px] text-primary uppercase tracking-[0.3em] font-black ml-1">Frecuencia</label>
          <div className="grid grid-cols-2 gap-4">
            {(['unique', 'daily', 'weekly', 'monthly'] as FrequencyType[]).map(f => (
              <button
                key={f}
                type="button"
                onClick={() => setFrequency(f)}
                className={`py-5 rounded-3xl border-2 text-xs font-black uppercase tracking-widest transition-all duration-500 ${
                  frequency === f 
                    ? 'bg-primary text-background border-primary shadow-xl shadow-primary/30 scale-[1.05] z-10' 
                    : 'border-ink/[0.03] bg-surface text-ink/30 hover:border-primary/20'
                }`}
              >
                {f === 'unique' ? 'Única' : f === 'daily' ? 'Diaria' : f === 'weekly' ? 'Semanal' : 'Mensual'}
              </button>
            ))}
          </div>
        </div>

        {/* Dynamic Fields */}
        <AnimatePresence mode="wait">
          {frequency === 'unique' && (
            <motion.div initial={{ opacity: 0, scale: 0.95 }} animate={{ opacity: 1, scale: 1 }} exit={{ opacity: 0, scale: 0.95 }} className="space-y-4">
              <div className="group">
                <label className="text-[9px] text-ink/30 uppercase tracking-widest font-bold ml-4 mb-1 block">Fecha</label>
                <input type="date" value={date} onChange={e => setDate(e.target.value)} className="w-full bg-surface p-5 rounded-3xl border border-ink/[0.03] focus:ring-4 focus:ring-primary/10 outline-none transition-all shadow-premium" />
              </div>
              <div className="group relative">
                <label className="text-[9px] text-ink/30 uppercase tracking-widest font-bold ml-4 mb-1 block">Hora</label>
                <input type="time" value={time} onChange={e => setTime(e.target.value)} className="w-full bg-surface p-5 rounded-3xl border border-ink/[0.03] focus:ring-4 focus:ring-primary/10 outline-none transition-all shadow-premium pr-14" />
                {time && (
                  <button type="button" onClick={() => setTime('')} className="absolute right-5 bottom-4 p-2 hover:bg-primary/10 rounded-full transition-colors">
                    <X className="w-4 h-4 text-primary stroke-[3]" />
                  </button>
                )}
              </div>
            </motion.div>
          )}

          {frequency === 'daily' && (
            <motion.div initial={{ opacity: 0, scale: 0.95 }} animate={{ opacity: 1, scale: 1 }} exit={{ opacity: 0, scale: 0.95 }} className="space-y-4">
               <div className="group relative">
                 <label className="text-[9px] text-ink/30 uppercase tracking-widest font-bold ml-4 mb-1 block">Hora (opcional)</label>
                 <input type="time" value={time} onChange={e => setTime(e.target.value)} className="w-full bg-surface p-5 rounded-3xl border border-ink/[0.03] focus:ring-4 focus:ring-primary/10 outline-none transition-all shadow-premium pr-14" />
                 {time && (
                   <button type="button" onClick={() => setTime('')} className="absolute right-5 bottom-4 p-2 hover:bg-primary/10 rounded-full transition-colors">
                     <X className="w-4 h-4 text-primary stroke-[3]" />
                   </button>
                 )}
               </div>
            </motion.div>
          )}

          {frequency === 'weekly' && (
            <motion.div initial={{ opacity: 0, scale: 0.95 }} animate={{ opacity: 1, scale: 1 }} exit={{ opacity: 0, scale: 0.95 }} className="space-y-8">
              <div className="space-y-3">
                <label className="text-[9px] text-ink/30 uppercase tracking-widest font-bold ml-4 block">Días de la semana</label>
                <div className="flex justify-between gap-2">
                  {(['L', 'M', 'W', 'J', 'V', 'S', 'D'] as WeekDay[]).map(d => (
                    <button
                      key={d}
                      type="button"
                      onClick={() => toggleDay(d)}
                      className={`w-11 h-11 rounded-2xl flex items-center justify-center text-xs font-black transition-all duration-500 ${
                        weekDays.includes(d) ? 'bg-primary text-background shadow-lg shadow-primary/30 scale-110 z-10' : 'bg-surface text-ink/20 border border-ink/[0.03]'
                      }`}
                    >
                      {d}
                    </button>
                  ))}
                </div>
              </div>
              <div className="group relative">
                <label className="text-[9px] text-ink/30 uppercase tracking-widest font-bold ml-4 mb-1 block">Hora</label>
                <input type="time" value={time} onChange={e => setTime(e.target.value)} className="w-full bg-surface p-5 rounded-3xl border border-ink/[0.03] focus:ring-4 focus:ring-primary/10 outline-none transition-all shadow-premium pr-14" />
                {time && (
                  <button type="button" onClick={() => setTime('')} className="absolute right-5 bottom-4 p-2 hover:bg-primary/10 rounded-full transition-colors">
                    <X className="w-4 h-4 text-primary stroke-[3]" />
                  </button>
                )}
              </div>
            </motion.div>
          )}

          {frequency === 'monthly' && (
            <motion.div initial={{ opacity: 0, scale: 0.95 }} animate={{ opacity: 1, scale: 1 }} exit={{ opacity: 0, scale: 0.95 }} className="space-y-8">
              <div className="flex gap-2 bg-ink/[0.03] p-1.5 rounded-3xl">
                <button 
                  type="button" 
                  onClick={() => setMonthlyMode('specific_day')}
                  className={`flex-1 py-3 rounded-2xl text-[10px] font-black uppercase tracking-wider transition-all ${monthlyMode === 'specific_day' ? 'bg-surface text-primary shadow-premium' : 'text-ink/30'}`}
                >
                  Día específico
                </button>
                <button 
                  type="button" 
                  onClick={() => setMonthlyMode('weekly_pattern')}
                  className={`flex-1 py-3 rounded-2xl text-[10px] font-black uppercase tracking-wider transition-all ${monthlyMode === 'weekly_pattern' ? 'bg-surface text-primary shadow-premium' : 'text-ink/30'}`}
                >
                  Patrón semanal
                </button>
              </div>
              
              {monthlyMode === 'specific_day' ? (
                <div className="group">
                  <label className="text-[9px] text-ink/30 uppercase tracking-widest font-bold ml-4 mb-1 block">Día del mes</label>
                  <input type="number" min="1" max="31" value={monthlyDay} onChange={e => setMonthlyDay(parseInt(e.target.value))} className="w-full bg-surface p-5 rounded-3xl border border-ink/[0.03] focus:ring-4 focus:ring-primary/10 outline-none transition-all shadow-premium" placeholder="Ej: 15" />
                </div>
              ) : (
                <div className="space-y-8">
                  <div className="space-y-3">
                    <label className="text-[9px] text-ink/30 uppercase tracking-widest font-bold ml-4 block">Semanas</label>
                    <div className="flex justify-between gap-2">
                      {[1, 2, 3, 4, 5].map(w => (
                        <button
                          key={w}
                          type="button"
                          onClick={() => toggleWeek(w)}
                          className={`flex-1 py-4 rounded-2xl border-2 text-[10px] font-black transition-all duration-500 ${
                            monthlyWeeks.includes(w) ? 'bg-primary text-background border-primary shadow-lg shadow-primary/30 scale-105 z-10' : 'bg-surface text-ink/20 border-ink/[0.03]'
                          }`}
                        >
                          {w === 5 ? 'ÚLT' : `SEM ${w}`}
                        </button>
                      ))}
                    </div>
                  </div>
                  <div className="space-y-3">
                    <label className="text-[9px] text-ink/30 uppercase tracking-widest font-bold ml-4 block">Día</label>
                    <div className="flex justify-between gap-2">
                      {(['L', 'M', 'W', 'J', 'V', 'S', 'D'] as WeekDay[]).map(d => (
                        <button
                          key={d}
                          type="button"
                          onClick={() => setMonthlyDayOfWeek(d)}
                          className={`w-11 h-11 rounded-2xl flex items-center justify-center text-xs font-black transition-all duration-500 ${
                            monthlyDayOfWeek === d ? 'bg-primary text-background shadow-lg shadow-primary/30 scale-110 z-10' : 'bg-surface text-ink/20 border border-ink/[0.03]'
                          }`}
                        >
                          {d}
                        </button>
                      ))}
                    </div>
                  </div>
                </div>
              )}
              
              <div className="group relative">
                <label className="text-[9px] text-ink/30 uppercase tracking-widest font-bold ml-4 mb-1 block">Hora</label>
                <input type="time" value={time} onChange={e => setTime(e.target.value)} className="w-full bg-surface p-5 rounded-3xl border border-ink/[0.03] focus:ring-4 focus:ring-primary/10 outline-none transition-all shadow-premium pr-14" />
                {time && (
                  <button type="button" onClick={() => setTime('')} className="absolute right-5 bottom-4 p-2 hover:bg-primary/10 rounded-full transition-colors">
                    <X className="w-4 h-4 text-primary stroke-[3]" />
                  </button>
                )}
              </div>
            </motion.div>
          )}
        </AnimatePresence>

        <div className="mt-auto pt-10">
          <button 
            type="submit"
            className="w-full bg-primary text-background font-black uppercase tracking-[0.2em] text-sm py-6 rounded-3xl shadow-2xl shadow-primary/40 active:scale-95 transition-all hover:brightness-110"
          >
            {initialData ? 'Actualizar tarea' : 'Confirmar tarea'}
          </button>
        </div>
      </form>
    </motion.div>
  );
}

function ScheduledView({ 
  tasks, 
  onBack, 
  onToggleActive, 
  onDelete,
  onEdit 
}: { 
  tasks: Task[], 
  onBack: () => void, 
  onToggleActive: (id: string) => void,
  onDelete: (id: string) => void,
  onEdit: (task: Task) => void,
  key?: string
}) {
  const [filter, setFilter] = useState<'active' | 'inactive'>('active');
  const filteredTasks = tasks.filter(t => filter === 'active' ? t.active : !t.active);

  return (
    <motion.div 
      initial={{ x: '-100%' }}
      animate={{ x: 0 }}
      exit={{ x: '-100%' }}
      className="flex-1 flex flex-col bg-background p-6"
    >
      <div className="flex items-center gap-4 mb-8">
        <button onClick={onBack} className="p-2 -ml-2 hover:bg-primary/10 rounded-full transition-colors">
          <ChevronLeft className="w-6 h-6" />
        </button>
        <h2 className="text-xl font-medium">Tareas Programadas</h2>
      </div>

      <div className="flex gap-2 mb-8 bg-primary-container/20 p-1 rounded-xl">
        <button 
          onClick={() => setFilter('active')}
          className={`flex-1 py-2 rounded-lg text-sm font-medium transition-all ${filter === 'active' ? 'bg-primary text-background shadow-sm' : 'text-ink/40'}`}
        >
          Activas
        </button>
        <button 
          onClick={() => setFilter('inactive')}
          className={`flex-1 py-2 rounded-lg text-sm font-medium transition-all ${filter === 'inactive' ? 'bg-primary text-background shadow-sm' : 'text-ink/40'}`}
        >
          Inactivas
        </button>
      </div>

      <div className="flex-1 overflow-y-auto no-scrollbar space-y-4">
        {filteredTasks.length === 0 ? (
          <p className="text-center py-12 text-ink/20">No hay tareas {filter === 'active' ? 'activas' : 'inactivas'}</p>
        ) : (
          filteredTasks.map(task => (
            <div key={task.id} className="bg-surface p-5 rounded-3xl flex items-center justify-between group border border-ink/[0.03] shadow-premium">
              <div className="flex-1">
                <h3 className={`text-[17px] font-bold ${!task.active ? 'opacity-30' : 'text-ink'}`}>{task.title}</h3>
                <p className="text-[11px] text-primary font-black uppercase tracking-widest mt-1.5">
                  {task.frequency === 'unique' ? 'Única' : 
                   task.frequency === 'daily' ? 'Diaria' : 
                   task.frequency === 'weekly' ? `Semanal (${task.weekDays?.join(' ')})` : 
                   `Mensual (${task.monthlyMode === 'specific_day' ? `Día ${task.monthlyDay}` : `Sem ${task.monthlyWeeks?.join(', ')} ${task.monthlyDayOfWeek}`})`}
                  {task.time && ` • ${task.time}`}
                </p>
              </div>
              <div className="flex gap-2">
                <button onClick={() => onEdit(task)} className="p-2.5 hover:bg-primary/10 rounded-xl text-primary transition-all active:scale-90">
                  <Edit2 className="w-4 h-4" />
                </button>
                <button onClick={() => onToggleActive(task.id)} className={`p-2.5 hover:bg-primary/10 rounded-xl transition-all active:scale-90 ${task.active ? 'text-success' : 'text-ink/20'}`}>
                  <Power className="w-4 h-4" />
                </button>
                <button onClick={() => onDelete(task.id)} className="p-2.5 hover:bg-rose-500/10 rounded-xl text-rose-500 transition-all active:scale-90">
                  <Trash2 className="w-4 h-4" />
                </button>
              </div>
            </div>
          ))
        )}
      </div>
    </motion.div>
  );
}

function HistoryView({ tasks, onBack }: { tasks: Task[], onBack: () => void, key?: string }) {
  const sortedTasks = [...tasks].sort((a, b) => (b.completedAt || 0) - (a.completedAt || 0));

  const formatDate = (timestamp?: number) => {
    if (!timestamp) return '';
    const date = new Date(timestamp);
    const today = new Date();
    const yesterday = new Date();
    yesterday.setDate(today.getDate() - 1);

    if (date.toDateString() === today.toDateString()) return 'Hoy';
    if (date.toDateString() === yesterday.toDateString()) return 'Ayer';
    return date.toLocaleDateString('es-ES', { day: 'numeric', month: 'long' });
  };

  return (
    <motion.div 
      initial={{ x: '-100%' }}
      animate={{ x: 0 }}
      exit={{ x: '-100%' }}
      className="flex-1 flex flex-col bg-background p-6"
    >
      <div className="flex items-center gap-4 mb-8">
        <button onClick={onBack} className="p-2 -ml-2 hover:bg-primary/10 rounded-full transition-colors">
          <ChevronLeft className="w-6 h-6" />
        </button>
        <h2 className="text-xl font-medium">Historial</h2>
      </div>

      <div className="flex-1 overflow-y-auto no-scrollbar space-y-4">
        {sortedTasks.length === 0 ? (
          <p className="text-center py-12 text-ink/20">No hay tareas completadas aún</p>
        ) : (
          sortedTasks.map(task => (
            <div key={task.id} className="flex items-start gap-5 bg-surface p-5 rounded-3xl border border-ink/[0.03] shadow-premium">
              <div className="mt-1 w-8 h-8 rounded-xl bg-success/10 flex items-center justify-center shrink-0">
                <Check className="w-4 h-4 text-success stroke-[3]" />
              </div>
              <div className="flex-1">
                <h3 className="text-[17px] font-bold text-ink/80 tracking-tight">{task.title}</h3>
                <div className="flex items-center gap-2 mt-1.5">
                  <div className="w-1 h-1 rounded-full bg-ink/20" />
                  <p className="text-[10px] text-ink/40 font-black uppercase tracking-[0.15em]">{formatDate(task.completedAt)}</p>
                </div>
              </div>
            </div>
          ))
        )}
      </div>
    </motion.div>
  );
}
