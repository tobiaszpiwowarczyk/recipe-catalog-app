import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RecipesComponent } from './recipes.component';
import { RecipeRoutingModule } from './recipes-routing.module';
import { DropdownModule } from 'src/app/modules/dropdown/dropdown.module';
import { ReactiveFormsModule } from '@angular/forms';
import { LoadingSpinnerModule } from 'src/app/modules/loading-spinner/loading-spinner.module';
import { RecipeComponent } from './componenets/recipe/recipe.component';
import { SliderModule } from 'src/app/modules/slider/slider.module';



@NgModule({
  declarations: [RecipesComponent, RecipeComponent],
  imports: [
    CommonModule,
    RecipeRoutingModule,
    DropdownModule,
    LoadingSpinnerModule,
    SliderModule,
    ReactiveFormsModule
  ]
})
export class RecipesModule { }
