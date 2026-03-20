import { Routes } from '@angular/router';
import { DashboardComponent } from './dashboard/dashboard';
import { HistoryComponent } from './history/history';
import { ManageComponent } from './manage/manage';

export const routes: Routes = [
  { path: '', component: DashboardComponent },
  { path: 'history', component: HistoryComponent },
  { path: 'manage', component: ManageComponent },
  { path: '**', redirectTo: '' }
];
