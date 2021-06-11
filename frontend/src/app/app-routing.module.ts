import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';


const routes: Routes = [
  {path: "",         loadChildren: "./page-modules/main/main.module#MainModule"},
  {path: 'login',    loadChildren: './page-modules/login/login.module#LoginModule'},
  {path: 'register', loadChildren: './page-modules/register/register.module#RegisterModule'}
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }