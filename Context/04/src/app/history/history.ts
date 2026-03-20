import { ChangeDetectionStrategy, Component, inject, computed } from '@angular/core';
import { CommonModule } from '@angular/common';
import { TaskService } from '../task.service';
import { MatIconModule } from '@angular/material/icon';
import { TaskInstance } from '../models';

@Component({
  selector: 'app-history',
  standalone: true,
  imports: [CommonModule, MatIconModule],
  template: `
    <div class="space-y-10">
      <header class="space-y-2 px-2">
        <h1 class="text-3xl font-black tracking-tighter uppercase">Registro de Flujo</h1>
        <p class="text-xs font-bold text-neutral-400 uppercase tracking-[0.2em]">Historial de Ejecución</p>
      </header>

      <div class="space-y-10">
        @for (group of historyGroups(); track group.date) {
          <div class="space-y-4">
            <div class="flex items-center justify-between px-2">
              <h2 class="text-[10px] font-bold text-neutral-400 uppercase tracking-[0.2em]">
                {{ formatDate(group.date) }}
              </h2>
              <div class="h-px flex-1 mx-4 bg-neutral-200 dark:bg-neutral-800"></div>
            </div>
            
            <div class="space-y-3">
              @for (inst of group.instances; track inst.id) {
                <div class="flex items-center gap-4 p-5 bg-white dark:bg-neutral-900 rounded-2xl border border-neutral-200 dark:border-neutral-800">
                  <div class="w-8 h-8 rounded-lg bg-emerald-500/10 flex items-center justify-center text-emerald-500 shadow-sm shadow-emerald-500/10">
                    <mat-icon class="text-lg">check_circle</mat-icon>
                  </div>
                  <div class="flex-1">
                    <h3 class="font-bold tracking-tight text-neutral-800 dark:text-neutral-100">{{ getTaskTitle(inst.taskId) }}</h3>
                    <div class="flex items-center gap-1 mt-1">
                      <mat-icon class="text-[14px] text-neutral-400 w-auto h-auto">done_all</mat-icon>
                      <span class="text-[11px] text-neutral-500 font-mono">
                        SYNC: {{ inst.completedAt | date:'HH:mm' }}
                      </span>
                    </div>
                  </div>
                </div>
              }
            </div>
          </div>
        } @empty {
          <div class="text-center py-24 text-neutral-400 bg-neutral-100/30 dark:bg-neutral-900/30 rounded-3xl border border-dashed border-neutral-300 dark:border-neutral-800">
            <mat-icon class="text-6xl opacity-10 mb-4">history</mat-icon>
            <p class="text-sm font-medium">Sin registros de ejecución previos.</p>
          </div>
        }
      </div>
    </div>
  `,
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class HistoryComponent {
  taskService = inject(TaskService);

  historyGroups = computed(() => {
    const instances = this.taskService.instances()
      .filter(i => i.completed)
      .sort((a, b) => b.date.localeCompare(a.date));

    const groups: { date: string, instances: TaskInstance[] }[] = [];
    instances.forEach(inst => {
      let group = groups.find(g => g.date === inst.date);
      if (!group) {
        group = { date: inst.date, instances: [] };
        groups.push(group);
      }
      group.instances.push(inst);
    });
    return groups;
  });

  getTaskTitle(taskId: string) {
    return this.taskService.tasks().find(t => t.id === taskId)?.title || 'Tarea eliminada';
  }

  formatDate(dateStr: string) {
    const date = new Date(dateStr + 'T00:00:00');
    const today = new Date();
    today.setHours(0,0,0,0);

    if (date.getTime() === today.getTime()) return 'Hoy';

    const yesterday = new Date(today);
    yesterday.setDate(yesterday.getDate() - 1);
    if (date.getTime() === yesterday.getTime()) return 'Ayer';

    return date.toLocaleDateString('es-ES', { weekday: 'long', day: 'numeric', month: 'long' });
  }
}
