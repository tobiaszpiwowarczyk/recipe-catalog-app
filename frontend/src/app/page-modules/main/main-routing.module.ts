import { RouterModule, Routes } from '@angular/router';
import { NgModule } from '@angular/core';
import { MainComponent } from './main.component';


export const routes: Routes = [
    {path: "", component: MainComponent, children: [
        {path: "", loadChildren: "./home/home.module#HomeModule"}
    ]}
];


@NgModule({
    imports: [RouterModule.forChild(routes)],
    exports: [RouterModule]
})
export class MainRoutingModule { }
