import { Directive } from '@angular/core';
import { ButtonComponent } from '../components/button/button.component';

@Directive({
  selector: 'app-button[appButtonNegative]'
})
export class ButtonNegativeDirective {

  constructor(
    private component: ButtonComponent
  ) {
    this.component.negative = true;
  }

}
