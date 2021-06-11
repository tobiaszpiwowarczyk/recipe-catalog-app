import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ModalComponent } from './modal.component';
import { ButtonModule } from '../button/button.module';
import { ModalContentCenteredDirective } from './directives/modal-content-centered.directive';



@NgModule({
  declarations: [ModalComponent, ModalContentCenteredDirective],
  imports: [
    CommonModule,
    ButtonModule
  ],
  exports: [ModalComponent, ModalContentCenteredDirective]
})
export class ModalModule { }
