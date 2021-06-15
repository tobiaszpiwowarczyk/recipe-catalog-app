import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { CreateRecipeComponent } from './create-recipe.component';
import { CreateRecipeRoutingModule } from './create-recipe-routing.module';
import { DropdownModule } from 'src/app/modules/dropdown/dropdown.module';
import { SliderModule } from 'src/app/modules/slider/slider.module';
import { InputModule } from 'src/app/modules/input/input.module';
import { ButtonModule } from 'src/app/modules/button/button.module';
import { TextareaModule } from 'src/app/modules/textarea/textarea.module';
import { ReactiveFormsModule } from '@angular/forms';
import { ModalModule } from 'src/app/modules/modal/modal.module';
import { LoadingSpinnerModule } from 'src/app/modules/loading-spinner/loading-spinner.module';



@NgModule({
  declarations: [CreateRecipeComponent],
  imports: [
    CommonModule,
    CreateRecipeRoutingModule,
    DropdownModule,
    SliderModule,
    InputModule,
    ButtonModule,
    TextareaModule,
    ReactiveFormsModule,
    ModalModule,
    LoadingSpinnerModule
  ]
})
export class CreateRecipeModule { }