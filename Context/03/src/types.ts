export type FrequencyType = 'unique' | 'daily' | 'weekly' | 'monthly';

export type WeekDay = 'L' | 'M' | 'W' | 'J' | 'V' | 'S' | 'D';

export type MonthlyMode = 'specific_day' | 'weekly_pattern';

export type WeeklyPattern = 'first_monday' | 'second_tuesday' | 'third_wednesday' | 'fourth_june' | 'last_friday';

export interface Task {
  id: string;
  title: string;
  frequency: FrequencyType;
  completed: boolean;
  active: boolean;
  createdAt: number;
  completedAt?: number;
  
  // Frequency specific fields
  date?: string; // For 'unique'
  time?: string; // Optional for all
  weekDays?: WeekDay[]; // For 'weekly'
  monthlyMode?: MonthlyMode; // For 'monthly'
  monthlyDay?: number; // For 'monthly' mode 1
  monthlyWeeks?: number[]; // For 'monthly' mode 2 (1, 2, 3, 4, 5)
  monthlyDayOfWeek?: WeekDay; // For 'monthly' mode 2
  weeklyPattern?: string; // Deprecated but keeping for compatibility
}

export const COLORS = {
  background: '#0F172A',
  text: '#E2E8F0',
  primary: '#38BDF8',
  completed: '#22C55E',
  muted: '#475569',
};
