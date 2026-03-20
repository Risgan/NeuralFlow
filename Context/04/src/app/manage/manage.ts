import { ChangeDetectionStrategy, Component, inject, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { TaskService } from '../task.service';
import { MatIconModule } from '@angular/material/icon';
import { Task } from '../models';
import { TaskFormComponent } from '../task-form/task-form';

@Component({
  selector: 'app-manage',
  standalone: true,
  imports: [CommonModule, MatIconModule, TaskFormComponent],
  template: `
    <div class="space-y-10">
      <header class="space-y-2 px-2">
        <h1 class="text-3xl font-black tracking-tighter uppercase">Gestión de Nodos</h1>
        <p class="text-xs font-bold text-neutral-400 uppercase tracking-[0.2em]">Configuración de Rutinas</p>
      </header>

      <div class="space-y-4">
        @for (task of taskService.tasks(); track task.id) {
          <div class="group relative flex items-center gap-4 p-5 bg-white dark:bg-neutral-900 rounded-2xl border border-neutral-200 dark:border-neutral-800 hover:border-primary/50 transition-all overflow-hidden">
            <div class="absolute top-0 left-0 w-1 h-full bg-primary" [class.opacity-0]="!task.active"></div>
            
            <div class="flex-1">
              <div class="flex items-center gap-2">
                <h3 class="font-bold tracking-tight" [class.opacity-40]="!task.active">{{ task.title }}</h3>
                @if (!task.active) {
                  <span class="text-[9px] bg-neutral-100 dark:bg-neutral-800 px-1.5 py-0.5 rounded-md uppercase font-black text-neutral-400 tracking-wider">Desactivado</span>
                }
              </div>
              <div class="flex items-center gap-3 mt-1.5">
                <div class="flex items-center gap-1 text-[11px] text-neutral-500 font-medium">
                  <mat-icon class="text-[14px] w-auto h-auto">sync</mat-icon>
                  <span>{{ getFrequencyLabel(task) }}</span>
                </div>
                @if (task.time) {
                  <div class="flex items-center gap-1 text-[11px] text-neutral-500 font-mono">
                    <mat-icon class="text-[14px] w-auto h-auto">schedule</mat-icon>
                    <span>{{ task.time }}</span>
                  </div>
                }
              </div>
            </div>

            <div class="flex items-center gap-1">
              <button (click)="editingTask.set(task)"
                      class="p-2.5 rounded-xl bg-neutral-50 dark:bg-neutral-800 hover:bg-neutral-100 dark:hover:bg-neutral-700 transition-colors text-neutral-600 dark:text-neutral-300"
                      title="Editar">
                <mat-icon class="text-xl">edit</mat-icon>
              </button>
              <button (click)="taskService.toggleTaskActive(task.id)"
                      class="p-2.5 rounded-xl bg-neutral-50 dark:bg-neutral-800 hover:bg-neutral-100 dark:hover:bg-neutral-700 transition-colors"
                      [title]="task.active ? 'Desactivar' : 'Activar'">
                <mat-icon class="text-xl" [class.text-primary]="task.active">{{ task.active ? 'visibility' : 'visibility_off' }}</mat-icon>
              </button>
              <button (click)="taskService.deleteTask(task.id)"
                      class="p-2.5 rounded-xl bg-red-50 dark:bg-red-900/10 text-red-400 hover:bg-red-100 dark:hover:bg-red-900/20 transition-colors"
                      title="Eliminar">
                <mat-icon class="text-xl">delete_outline</mat-icon>
              </button>
            </div>
          </div>
        } @empty {
          <div class="text-center py-24 text-neutral-400 bg-neutral-100/30 dark:bg-neutral-900/30 rounded-3xl border border-dashed border-neutral-300 dark:border-neutral-800">
            <mat-icon class="text-6xl opacity-10 mb-4">terminal</mat-icon>
            <p class="text-sm font-medium">No se han inicializado tareas en el sistema.</p>
          </div>
        }
      </div>
    </div>

    @if (editingTask()) {
      <app-task-form [task]="editingTask()!" (closeForm)="editingTask.set(null)"></app-task-form>
    }
  `,
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class ManageComponent {
  taskService = inject(TaskService);
  editingTask = signal<Task | null>(null);

  getFrequencyLabel(task: Task): string {
    switch (task.frequency) {
      case 'once': return `Una vez (${task.date})`;
      case 'daily': return 'Diariamente';
      case 'weekly': {
        const days = task.weeklyConfig?.days.map(d => ['Dom', 'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb'][d]).join(', ');
        return `Semanalmente (${days})`;
      }
      case 'monthly': {
        if (task.monthlyConfig?.type === 'day') return `Mensualmente (Día ${task.monthlyConfig.day})`;
        const p = task.monthlyConfig?.pattern;
        const occ = { first: 'Primer', second: 'Segundo', third: 'Tercer', fourth: 'Cuarto', last: 'Último' }[p?.occurrence || 'first'];
        const day = ['Domingo', 'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado'][p?.dayOfWeek || 0];
        return `Mensualmente (${occ} ${day})`;
      }
      default: return '';
    }
  }
}
