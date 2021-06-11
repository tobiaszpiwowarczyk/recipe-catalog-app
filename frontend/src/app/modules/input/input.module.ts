import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { InputComponent } from './input.component';
import { InputAutofocusDirective } from './directives/input-autofocus.directive';
import { InputFluidDirective } from './directives/input-fluid.directive';
import { FormsModule } from '@angular/forms';



@NgModule({
  declarations: [
    InputComponent,
    InputAutofocusDirective,
    InputFluidDirective
  ],
  imports: [
    CommonModule,
    FormsModule
  ],
  exports: [
    InputComponent,
    InputAutofocusDirective,
    InputFluidDirective
  ]
})
export class InputModule { }
