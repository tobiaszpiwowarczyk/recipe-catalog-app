import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ButtonIconicDirective } from './directives/button-iconic.directive';
import { ButtonComponent } from './components/button/button.component';
import { ButtonGroupComponent } from './components/button-group/button-group.component';



@NgModule({
  declarations: [
    ButtonComponent,
    ButtonIconicDirective,
    ButtonGroupComponent
  ],
  imports: [
    CommonModule
  ],
  exports: [
    ButtonComponent,
    ButtonIconicDirective,
    ButtonGroupComponent
  ]
})
export class ButtonModule { }
