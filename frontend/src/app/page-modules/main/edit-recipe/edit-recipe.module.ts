import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { EditRecipeComponent } from './edit-recipe.component';
import { EditRecipeRoutingModule } from './edit-recipe-routing.module';
import { ReactiveFormsModule } from '@angular/forms';
import { ButtonModule } from 'src/app/modules/button/button.module';
import { DropdownModule } from 'src/app/modules/dropdown/dropdown.module';
import { InputModule } from 'src/app/modules/input/input.module';
import { LoadingSpinnerModule } from 'src/app/modules/loading-spinner/loading-spinner.module';
import { ModalModule } from 'src/app/modules/modal/modal.module';
import { SliderModule } from 'src/app/modules/slider/slider.module';
import { TextareaModule } from 'src/app/modules/textarea/textarea.module';



@NgModule({
  declarations: [EditRecipeComponent],
  imports: [
    CommonModule,
    EditRecipeRoutingModule,
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
export class EditRecipeModule { }
