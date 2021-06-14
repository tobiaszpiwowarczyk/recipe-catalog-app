import { RouterModule, Routes } from '@angular/router';
import { NgModule } from '@angular/core';
import { MainComponent } from './main.component';


export const routes: Routes = [
    {path: "", component: MainComponent, children: [
        {path: "", loadChildren: "./home/home.module#HomeModule"},
        {path: "recipes", loadChildren: "./recipes/recipes.module#RecipesModule"},
        {path: "recipe-data", loadChildren: "./recipe-data/recipe-data.module#RecipeDataModule"}
    ]}
];


@NgModule({
    imports: [RouterModule.forChild(routes)],
    exports: [RouterModule]
})
export class MainRoutingModule { }
