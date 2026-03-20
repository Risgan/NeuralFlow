import { Task } from './types';

export const MOCK_TASKS: Task[] = [
  {
    id: '1',
    title: 'Barrer',
    frequency: 'daily',
    completed: false,
    active: true,
    createdAt: Date.now(),
  },
  {
    id: '2',
    title: 'Comprar carne',
    frequency: 'weekly',
    weekDays: ['L', 'W', 'V'],
    completed: false,
    active: true,
    createdAt: Date.now(),
  },
  {
    id: '3',
    title: 'Reunión semilla',
    frequency: 'daily',
    time: '09:00',
    completed: false,
    active: true,
    createdAt: Date.now(),
  },
  {
    id: '4',
    title: 'Hacer ejercicio',
    frequency: 'daily',
    completed: true,
    active: true,
    createdAt: Date.now() - 86400000,
    completedAt: Date.now() - 3600000,
  },
  {
    id: '5',
    title: 'Lavar ropa',
    frequency: 'weekly',
    weekDays: ['S'],
    completed: true,
    active: true,
    createdAt: Date.now() - 172800000,
    completedAt: Date.now() - 172800000 + 7200000,
  }
];
