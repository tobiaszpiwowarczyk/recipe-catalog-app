import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { RecipeDataComponent } from './recipe-data.component';

export const routes: Routes = [
    {path: "", component: RecipeDataComponent}
];

@NgModule({
    imports: [RouterModule.forChild(routes)],
    exports: [RouterModule]
})
export class RecipeDataRoutingModule { }
