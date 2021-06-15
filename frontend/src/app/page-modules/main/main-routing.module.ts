import { RouterModule, Routes } from '@angular/router';
import { NgModule } from '@angular/core';
import { MainComponent } from './main.component';


export const routes: Routes = [
    {path: "", component: MainComponent, children: [
        {path: "", loadChildren: "./home/home.module#HomeModule"},
        {path: "recipes", loadChildren: "./recipes/recipes.module#RecipesModule"},
        {path: "recipe-data", loadChildren: "./recipe-data/recipe-data.module#RecipeDataModule"},
        {path: "create-recipe", loadChildren: "./create-recipe/create-recipe.module#CreateRecipeModule"},
        {path: "edit-recipe", loadChildren: "./edit-recipe/edit-recipe.module#EditRecipeModule"}
    ]}
];


@NgModule({
    imports: [RouterModule.forChild(routes)],
    exports: [RouterModule]
})
export class MainRoutingModule { }
