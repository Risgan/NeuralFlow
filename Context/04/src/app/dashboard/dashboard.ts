import { ChangeDetectionStrategy, Component, inject, signal, AfterViewInit, computed, PLATFORM_ID } from '@angular/core';
import { CommonModule, isPlatformBrowser } from '@angular/common';
import { TaskService } from '../task.service';
import { MatIconModule } from '@angular/material/icon';
import { animate, stagger } from 'motion';
import { TaskFormComponent } from '../task-form/task-form';

@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [CommonModule, MatIconModule, TaskFormComponent],
  template: `
    <div class="space-y-10">
      <!-- Header / Big Number -->
      <header class="relative py-10 flex flex-col items-center">
        <div class="absolute inset-0 flex items-center justify-center opacity-5">
          <mat-icon class="text-[200px] text-primary">hub</mat-icon>
        </div>
        <div class="relative z-10 text-center space-y-1">
          <div class="text-9xl font-black tracking-tighter text-primary animate-in fade-in zoom-in duration-1000">
            {{ taskService.pendingCount() }}
          </div>
          <p class="text-neutral-500 dark:text-neutral-400 font-bold uppercase tracking-[0.3em] text-[10px]">
            Nodos pendientes
          </p>
        </div>
      </header>

      <!-- Task List -->
      <section class="space-y-10 pb-10">
        <!-- Pending -->
        <div class="space-y-4">
          <div class="flex items-center justify-between px-2">
            <h2 class="text-[10px] font-bold text-neutral-400 uppercase tracking-[0.2em]">Cola de Procesamiento</h2>
            <div class="h-px flex-1 mx-4 bg-neutral-200 dark:bg-neutral-800"></div>
          </div>
          
          <div class="space-y-3" id="pending-list">
            @for (item of pendingTasks(); track item.task.id) {
              <div class="group relative flex items-center gap-4 p-5 bg-white dark:bg-neutral-900 rounded-2xl border border-neutral-200 dark:border-neutral-800 hover:border-primary/50 transition-all cursor-pointer overflow-hidden"
                   tabindex="0"
                   (keydown.enter)="taskService.toggleComplete(item.task.id, taskService.today())"
                   (click)="taskService.toggleComplete(item.task.id, taskService.today())">
                <!-- Tech Accent -->
                <div class="absolute top-0 left-0 w-1 h-full bg-primary opacity-0 group-hover:opacity-100 transition-opacity"></div>
                
                <div class="w-7 h-7 rounded-lg border-2 border-neutral-200 dark:border-neutral-700 flex items-center justify-center group-hover:border-primary transition-colors bg-neutral-50 dark:bg-neutral-800">
                  <div class="w-3 h-3 bg-primary rounded-sm scale-0 transition-transform duration-300 group-hover:scale-50"></div>
                </div>
                
                <div class="flex-1">
                  <h3 class="font-semibold text-neutral-800 dark:text-neutral-100 tracking-tight">{{ item.task.title }}</h3>
                  @if (item.task.time) {
                    <div class="flex items-center gap-1 mt-1">
                      <mat-icon class="text-[14px] text-neutral-400 w-auto h-auto">schedule</mat-icon>
                      <span class="text-[11px] text-neutral-500 font-mono">{{ item.task.time }}</span>
                    </div>
                  }
                </div>

                <mat-icon class="text-neutral-300 dark:text-neutral-700 opacity-0 group-hover:opacity-100 transition-opacity">chevron_right</mat-icon>
              </div>
            } @empty {
              <div class="text-center py-16 text-neutral-400 bg-neutral-100/30 dark:bg-neutral-900/30 rounded-3xl border border-dashed border-neutral-300 dark:border-neutral-800">
                <mat-icon class="text-4xl mb-2 opacity-20">auto_awesome</mat-icon>
                <p class="text-sm font-medium tracking-wide">Sistema Optimizado. Sin tareas pendientes.</p>
              </div>
            }
          </div>
        </div>

        <!-- Completed -->
        @if (completedTasks().length > 0) {
          <div class="space-y-4">
            <div class="flex items-center justify-between px-2">
              <h2 class="text-[10px] font-bold text-neutral-400 uppercase tracking-[0.2em]">Completadas</h2>
              <div class="h-px flex-1 mx-4 bg-neutral-200 dark:bg-neutral-800"></div>
            </div>
            
            <div class="space-y-2 opacity-50">
              @for (item of completedTasks(); track item.task.id) {
                <div class="flex items-center gap-4 p-4 bg-neutral-100/50 dark:bg-neutral-800/30 rounded-xl border border-transparent cursor-pointer"
                     tabindex="0"
                     (keydown.enter)="taskService.toggleComplete(item.task.id, taskService.today())"
                     (click)="taskService.toggleComplete(item.task.id, taskService.today())">
                  <div class="w-6 h-6 rounded-lg bg-primary/20 flex items-center justify-center">
                    <mat-icon class="text-primary text-sm">check</mat-icon>
                  </div>
                  <div class="flex-1">
                    <h3 class="text-sm font-medium line-through text-neutral-500">{{ item.task.title }}</h3>
                  </div>
                </div>
              }
            </div>
          </div>
        }
      </section>

      <!-- FAB -->
      <button (click)="showForm.set(true)"
              class="fixed bottom-24 right-6 w-14 h-14 bg-primary text-white rounded-2xl shadow-xl shadow-primary/40 flex items-center justify-center hover:scale-105 active:scale-95 transition-all z-50">
        <mat-icon class="text-2xl">add</mat-icon>
      </button>

      <!-- Form Modal -->
      @if (showForm()) {
        <app-task-form (closeForm)="showForm.set(false)"></app-task-form>
      }
    </div>
  `,
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class DashboardComponent implements AfterViewInit {
  private platformId = inject(PLATFORM_ID);
  taskService = inject(TaskService);
  showForm = signal(false);

  pendingTasks = computed(() => this.taskService.todayTasks().filter(t => !t.completed));
  completedTasks = computed(() => this.taskService.todayTasks().filter(t => t.completed));

  ngAfterViewInit() {
    if (isPlatformBrowser(this.platformId)) {
      this.animateList();
    }
  }

  private animateList() {
    const items = document.querySelectorAll('#pending-list > div');
    if (items.length > 0) {
      animate(items, { opacity: [0, 1], y: [10, 0] }, { delay: stagger(0.05), duration: 0.4 });
    }
  }
}
