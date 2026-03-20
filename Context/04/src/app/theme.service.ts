import { Injectable, signal, effect, inject, PLATFORM_ID } from '@angular/core';
import { isPlatformBrowser } from '@angular/common';

@Injectable({
  providedIn: 'root'
})
export class ThemeService {
  private platformId = inject(PLATFORM_ID);
  darkMode = signal<boolean>(this.loadTheme());

  constructor() {
    effect(() => {
      const isDark = this.darkMode();
      if (isPlatformBrowser(this.platformId)) {
        if (isDark) {
          document.body.classList.add('dark');
        } else {
          document.body.classList.remove('dark');
        }
        localStorage.setItem('focus_theme', isDark ? 'dark' : 'light');
      }
    });
  }

  toggle() {
    this.darkMode.update(v => !v);
  }

  private loadTheme(): boolean {
    if (isPlatformBrowser(this.platformId)) {
      const saved = localStorage.getItem('focus_theme');
      if (saved) return saved === 'dark';
      return window.matchMedia('(prefers-color-scheme: dark)').matches;
    }
    return false;
  }
}
