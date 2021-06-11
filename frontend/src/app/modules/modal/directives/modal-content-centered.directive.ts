import { Directive } from '@angular/core';
import { ModalComponent } from '../modal.component';

@Directive({
  selector: 'app-modal[appModalContentCentered]'
})
export class ModalContentCenteredDirective {

  constructor(
    private component: ModalComponent
  ) {
    this.component.modalContentCentered = true;
  }

}
