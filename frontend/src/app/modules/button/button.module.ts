import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ButtonIconicDirective } from './directives/button-iconic.directive';
import { ButtonComponent } from './components/button/button.component';
import { ButtonGroupComponent } from './components/button-group/button-group.component';
import { ButtonFluidDirective } from './directives/button-fluid.directive';
import { ButtonNegativeDirective } from './directives/button-negative.directive';



@NgModule({
  declarations: [
    ButtonComponent,
    ButtonIconicDirective,
    ButtonGroupComponent,
    ButtonFluidDirective,
    ButtonNegativeDirective
  ],
  imports: [
    CommonModule
  ],
  exports: [
    ButtonComponent,
    ButtonIconicDirective,
    ButtonGroupComponent,
    ButtonFluidDirective,
    ButtonNegativeDirective
  ]
})
export class ButtonModule { }
