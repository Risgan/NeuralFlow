
export type Frequency = 'once' | 'daily' | 'weekly' | 'monthly';

export interface WeeklyConfig {
  days: number[]; // 0-6 (Sunday-Saturday)
}

export interface MonthlyConfig {
  type: 'day' | 'pattern';
  day?: number; // 1-31
  pattern?: {
    occurrence: 'first' | 'second' | 'third' | 'fourth' | 'last';
    dayOfWeek: number;
  };
}

export interface Task {
  id: string;
  title: string;
  time?: string; // HH:mm
  frequency: Frequency;
  date?: string; // ISO date for 'once'
  weeklyConfig?: WeeklyConfig;
  monthlyConfig?: MonthlyConfig;
  active: boolean;
  createdAt: number;
}

export interface TaskInstance {
  id: string;
  taskId: string;
  date: string; // YYYY-MM-DD
  completed: boolean;
  completedAt?: number;
}
