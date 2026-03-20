import { Injectable, signal, computed, effect, inject, PLATFORM_ID } from '@angular/core';
import { isPlatformBrowser } from '@angular/common';
import { Task, TaskInstance } from './models';

@Injectable({
  providedIn: 'root'
})
export class TaskService {
  private platformId = inject(PLATFORM_ID);
  private tasksSignal = signal<Task[]>(this.loadTasks());
  private instancesSignal = signal<TaskInstance[]>(this.loadInstances());

  tasks = computed(() => this.tasksSignal());
  instances = computed(() => this.instancesSignal());

  today = computed(() => {
    const now = new Date();
    return now.toISOString().split('T')[0];
  });

  todayTasks = computed(() => {
    const todayStr = this.today();
    const allTasks = this.tasksSignal();
    const allInstances = this.instancesSignal();

    // Filter tasks that should appear today
    return allTasks.filter(task => {
      if (!task.active) return false;
      return this.isTaskDueOn(task, todayStr);
    }).map(task => {
      const instance = allInstances.find(i => i.taskId === task.id && i.date === todayStr);
      return {
        task,
        completed: instance?.completed || false,
        instanceId: instance?.id
      };
    });
  });

  pendingCount = computed(() => {
    return this.todayTasks().filter(t => !t.completed).length;
  });

  constructor() {
    effect(() => {
      if (isPlatformBrowser(this.platformId)) {
        localStorage.setItem('focus_tasks', JSON.stringify(this.tasksSignal()));
      }
    });
    effect(() => {
      if (isPlatformBrowser(this.platformId)) {
        localStorage.setItem('focus_instances', JSON.stringify(this.instancesSignal()));
      }
    });
  }

  private loadTasks(): Task[] {
    if (isPlatformBrowser(this.platformId)) {
      const saved = localStorage.getItem('focus_tasks');
      return saved ? JSON.parse(saved) : [];
    }
    return [];
  }

  private loadInstances(): TaskInstance[] {
    if (isPlatformBrowser(this.platformId)) {
      const saved = localStorage.getItem('focus_instances');
      return saved ? JSON.parse(saved) : [];
    }
    return [];
  }

  addTask(task: Omit<Task, 'id' | 'createdAt' | 'active'>) {
    const newTask: Task = {
      ...task,
      id: crypto.randomUUID(),
      createdAt: Date.now(),
      active: true
    };
    this.tasksSignal.update(tasks => [...tasks, newTask]);
  }

  updateTask(updatedTask: Task) {
    this.tasksSignal.update(tasks => tasks.map(t => t.id === updatedTask.id ? updatedTask : t));
  }

  deleteTask(id: string) {
    this.tasksSignal.update(tasks => tasks.filter(t => t.id !== id));
    this.instancesSignal.update(instances => instances.filter(i => i.taskId !== id));
  }

  toggleTaskActive(id: string) {
    this.tasksSignal.update(tasks => tasks.map(t => {
      if (t.id === id) return { ...t, active: !t.active };
      return t;
    }));
  }

  toggleComplete(taskId: string, date: string) {
    const instances = this.instancesSignal();
    const existingIndex = instances.findIndex(i => i.taskId === taskId && i.date === date);

    if (existingIndex > -1) {
      const updated = [...instances];
      updated[existingIndex] = {
        ...updated[existingIndex],
        completed: !updated[existingIndex].completed,
        completedAt: !updated[existingIndex].completed ? Date.now() : undefined
      };
      this.instancesSignal.set(updated);
    } else {
      const newInstance: TaskInstance = {
        id: crypto.randomUUID(),
        taskId,
        date,
        completed: true,
        completedAt: Date.now()
      };
      this.instancesSignal.update(inst => [...inst, newInstance]);
    }
  }

  private isTaskDueOn(task: Task, dateStr: string): boolean {
    const date = new Date(dateStr + 'T00:00:00');
    const dayOfWeek = date.getDay();
    const dayOfMonth = date.getDate();

    switch (task.frequency) {
      case 'once':
        return task.date === dateStr;
      case 'daily':
        return true;
      case 'weekly':
        return task.weeklyConfig?.days.includes(dayOfWeek) || false;
      case 'monthly':
        if (task.monthlyConfig?.type === 'day') {
          return task.monthlyConfig.day === dayOfMonth;
        } else if (task.monthlyConfig?.pattern) {
          const { occurrence, dayOfWeek: targetDay } = task.monthlyConfig.pattern;
          if (dayOfWeek !== targetDay) return false;

          if (occurrence === 'last') {
            const nextWeek = new Date(date);
            nextWeek.setDate(date.getDate() + 7);
            return nextWeek.getMonth() !== date.getMonth();
          }

          const weekNum = Math.floor((dayOfMonth - 1) / 7) + 1;
          const map: Record<string, number> = { first: 1, second: 2, third: 3, fourth: 4 };
          return weekNum === map[occurrence];
        }
        return false;
      default:
        return false;
    }
  }
}
