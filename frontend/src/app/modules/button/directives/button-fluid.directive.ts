import { Directive } from '@angular/core';
import { ButtonComponent } from '../components/button/button.component';

@Directive({
  selector: 'app-button[appButtonFluid]'
})
export class ButtonFluidDirective {

  constructor(
    private component: ButtonComponent
  ) {
    this.component.fluid = true;
  }

}