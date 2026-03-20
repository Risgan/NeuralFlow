import { ChangeDetectionStrategy, Component, EventEmitter, Input, OnInit, Output, inject, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ReactiveFormsModule, FormBuilder, Validators, FormGroup } from '@angular/forms';
import { MatIconModule } from '@angular/material/icon';
import { TaskService } from '../task.service';
import { Frequency, Task } from '../models';

@Component({
  selector: 'app-task-form',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, MatIconModule],
  template: `
    <div class="fixed inset-0 z-50 flex items-end sm:items-center justify-center p-4 bg-neutral-950/60 backdrop-blur-md animate-in fade-in duration-300">
      <div class="w-full max-w-md bg-white dark:bg-neutral-900 rounded-[2.5rem] shadow-2xl overflow-hidden animate-in slide-in-from-bottom-10 duration-500 border border-neutral-200 dark:border-neutral-800">
        <div class="p-8 space-y-8">
          <header class="flex items-center justify-between">
            <div class="space-y-1">
              <h2 class="text-2xl font-black tracking-tighter uppercase">{{ task ? 'Sincronizar Nodo' : 'Nuevo Nodo' }}</h2>
              <p class="text-[10px] font-bold text-neutral-400 uppercase tracking-[0.2em]">Configuración de Parámetros</p>
            </div>
            <button (click)="closeForm.emit()" class="p-2.5 bg-neutral-100 dark:bg-neutral-800 hover:bg-neutral-200 dark:hover:bg-neutral-700 rounded-2xl transition-colors">
              <mat-icon class="text-xl">close</mat-icon>
            </button>
          </header>

          <form [formGroup]="form" (ngSubmit)="onSubmit()" class="space-y-8">
            <!-- Title -->
            <div class="space-y-2">
              <label for="task-title" class="text-[10px] font-bold text-neutral-400 uppercase tracking-[0.2em] ml-1">Identificador</label>
              <input id="task-title" type="text" formControlName="title" placeholder="Nombre de la tarea..."
                     class="w-full px-5 py-4 bg-neutral-50 dark:bg-neutral-800/50 border-2 border-transparent focus:border-primary/30 rounded-2xl transition-all outline-none font-medium">
            </div>

            <div class="grid grid-cols-2 gap-4">
              <!-- Time -->
              <div class="space-y-2">
                <label for="task-time" class="text-[10px] font-bold text-neutral-400 uppercase tracking-[0.2em] ml-1">Horario</label>
                <input id="task-time" type="time" formControlName="time"
                       class="w-full px-5 py-4 bg-neutral-50 dark:bg-neutral-800/50 border-2 border-transparent focus:border-primary/30 rounded-2xl transition-all outline-none font-mono text-sm">
              </div>

              <!-- Frequency Selector -->
              <div class="space-y-2">
                <label for="task-frequency" class="text-[10px] font-bold text-neutral-400 uppercase tracking-[0.2em] ml-1">Frecuencia</label>
                <select id="task-frequency" formControlName="frequency" class="w-full px-5 py-4 bg-neutral-50 dark:bg-neutral-800/50 border-2 border-transparent focus:border-primary/30 rounded-2xl transition-all outline-none font-medium text-sm appearance-none">
                  @for (freq of frequencies; track freq.value) {
                    <option [value]="freq.value">{{ freq.label }}</option>
                  }
                </select>
              </div>
            </div>

            <!-- Conditional Configs -->
            @if (form.get('frequency')?.value === 'once') {
              <div class="space-y-2 animate-in fade-in slide-in-from-top-2">
                <label for="task-date" class="text-[10px] font-bold text-neutral-400 uppercase tracking-[0.2em] ml-1">Fecha de Ejecución</label>
                <input id="task-date" type="date" formControlName="date"
                       class="w-full px-5 py-4 bg-neutral-50 dark:bg-neutral-800/50 border-2 border-transparent focus:border-primary/30 rounded-2xl transition-all outline-none font-mono text-sm">
              </div>
            }

            @if (form.get('frequency')?.value === 'weekly') {
              <div class="space-y-3 animate-in fade-in slide-in-from-top-2">
                <span class="text-[10px] font-bold text-neutral-400 uppercase tracking-[0.2em] ml-1">Días de Ciclo</span>
                <div class="flex justify-between gap-1">
                  @for (day of weekDays; track day.value) {
                    <button type="button" (click)="toggleDay(day.value)"
                            [class.bg-primary]="selectedDays().includes(day.value)"
                            [class.text-white]="selectedDays().includes(day.value)"
                            [class.bg-neutral-100]="!selectedDays().includes(day.value)"
                            [class.dark:bg-neutral-800]="!selectedDays().includes(day.value)"
                            class="w-10 h-10 rounded-xl text-xs font-black transition-all">
                      {{ day.label }}
                    </button>
                  }
                </div>
              </div>
            }

            @if (form.get('frequency')?.value === 'monthly') {
              <div class="space-y-4 animate-in fade-in slide-in-from-top-2">
                <div class="flex p-1 bg-neutral-100 dark:bg-neutral-800 rounded-2xl">
                  <button type="button" (click)="monthlyType.set('day')"
                          [class.bg-white]="monthlyType() === 'day'"
                          [class.dark:bg-neutral-700]="monthlyType() === 'day'"
                          [class.shadow-sm]="monthlyType() === 'day'"
                          class="flex-1 py-2.5 rounded-xl text-[10px] font-bold uppercase tracking-wider transition-all">
                    Día
                  </button>
                  <button type="button" (click)="monthlyType.set('pattern')"
                          [class.bg-white]="monthlyType() === 'pattern'"
                          [class.dark:bg-neutral-700]="monthlyType() === 'pattern'"
                          [class.shadow-sm]="monthlyType() === 'pattern'"
                          class="flex-1 py-2.5 rounded-xl text-[10px] font-bold uppercase tracking-wider transition-all">
                    Patrón
                  </button>
                </div>

                @if (monthlyType() === 'day') {
                  <label for="monthly-day" class="sr-only">Día del mes</label>
                  <input id="monthly-day" type="number" formControlName="monthlyDay" min="1" max="31" placeholder="Día (1-31)"
                         class="w-full px-5 py-4 bg-neutral-50 dark:bg-neutral-800/50 border-2 border-transparent focus:border-primary/30 rounded-2xl transition-all outline-none font-mono text-sm">
                } @else {
                  <div class="grid grid-cols-2 gap-3">
                    <label for="monthly-occurrence" class="sr-only">Ocurrencia</label>
                    <select id="monthly-occurrence" formControlName="monthlyOccurrence" class="px-4 py-3.5 bg-neutral-50 dark:bg-neutral-800/50 rounded-2xl text-sm outline-none font-medium">
                      <option value="first">Primer</option>
                      <option value="second">Segundo</option>
                      <option value="third">Tercer</option>
                      <option value="fourth">Cuarto</option>
                      <option value="last">Último</option>
                    </select>
                    <label for="monthly-day-of-week" class="sr-only">Día de la semana</label>
                    <select id="monthly-day-of-week" formControlName="monthlyDayOfWeek" class="px-4 py-3.5 bg-neutral-50 dark:bg-neutral-800/50 rounded-2xl text-sm outline-none font-medium">
                      @for (day of weekDaysFull; track day.value) {
                        <option [value]="day.value">{{ day.label }}</option>
                      }
                    </select>
                  </div>
                }
              </div>
            }

            <button type="submit" [disabled]="form.invalid"
                    class="w-full py-5 bg-primary text-white rounded-[1.5rem] font-black uppercase tracking-[0.2em] text-xs shadow-xl shadow-primary/30 hover:shadow-primary/50 active:scale-[0.98] disabled:opacity-50 disabled:scale-100 transition-all">
              {{ task ? 'Actualizar Sistema' : 'Inicializar Nodo' }}
            </button>
          </form>
        </div>
      </div>
    </div>
  `,
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class TaskFormComponent implements OnInit {
  @Input() task?: Task;
  @Output() closeForm = new EventEmitter<void>();

  private fb = inject(FormBuilder);
  private taskService = inject(TaskService);

  form: FormGroup;
  selectedDays = signal<number[]>([]);
  monthlyType = signal<'day' | 'pattern'>('day');

  frequencies: { label: string, value: Frequency }[] = [
    { label: 'Única', value: 'once' },
    { label: 'Diaria', value: 'daily' },
    { label: 'Semanal', value: 'weekly' },
    { label: 'Mensual', value: 'monthly' },
  ];

  weekDays = [
    { label: 'D', value: 0 }, { label: 'L', value: 1 }, { label: 'M', value: 2 },
    { label: 'X', value: 3 }, { label: 'J', value: 4 }, { label: 'V', value: 5 }, { label: 'S', value: 6 }
  ];

  weekDaysFull = [
    { label: 'Domingo', value: 0 }, { label: 'Lunes', value: 1 }, { label: 'Martes', value: 2 },
    { label: 'Miércoles', value: 3 }, { label: 'Jueves', value: 4 }, { label: 'Viernes', value: 5 }, { label: 'Sábado', value: 6 }
  ];

  constructor() {
    this.form = this.fb.group({
      title: ['', Validators.required],
      time: [''],
      frequency: ['once', Validators.required],
      date: [new Date().toISOString().split('T')[0]],
      monthlyDay: [1],
      monthlyOccurrence: ['first'],
      monthlyDayOfWeek: [1]
    });
  }

  ngOnInit() {
    if (this.task) {
      this.form.patchValue({
        title: this.task.title,
        time: this.task.time || '',
        frequency: this.task.frequency,
        date: this.task.date || new Date().toISOString().split('T')[0],
        monthlyDay: this.task.monthlyConfig?.day || 1,
        monthlyOccurrence: this.task.monthlyConfig?.pattern?.occurrence || 'first',
        monthlyDayOfWeek: this.task.monthlyConfig?.pattern?.dayOfWeek || 1
      });

      if (this.task.frequency === 'weekly' && this.task.weeklyConfig) {
        this.selectedDays.set(this.task.weeklyConfig.days);
      }

      if (this.task.frequency === 'monthly' && this.task.monthlyConfig) {
        this.monthlyType.set(this.task.monthlyConfig.type);
      }
    }
  }

  setFrequency(freq: Frequency) {
    this.form.patchValue({ frequency: freq });
  }

  toggleDay(day: number) {
    const current = this.selectedDays();
    if (current.includes(day)) {
      this.selectedDays.set(current.filter(d => d !== day));
    } else {
      this.selectedDays.set([...current, day]);
    }
  }

  onSubmit() {
    if (this.form.invalid) return;

    const val = this.form.value;
    const taskData: Omit<Task, 'id' | 'createdAt' | 'active'> = {
      title: val.title,
      time: val.time || undefined,
      frequency: val.frequency,
    };

    if (val.frequency === 'once') {
      taskData.date = val.date;
    } else if (val.frequency === 'weekly') {
      taskData.weeklyConfig = { days: this.selectedDays() };
    } else if (val.frequency === 'monthly') {
      if (this.monthlyType() === 'day') {
        taskData.monthlyConfig = { type: 'day', day: val.monthlyDay };
      } else {
        taskData.monthlyConfig = {
          type: 'pattern',
          pattern: {
            occurrence: val.monthlyOccurrence,
            dayOfWeek: parseInt(val.monthlyDayOfWeek)
          }
        };
      }
    }

    if (this.task) {
      this.taskService.updateTask({
        ...this.task,
        ...taskData
      });
    } else {
      this.taskService.addTask(taskData);
    }

    this.closeForm.emit();
  }
}
