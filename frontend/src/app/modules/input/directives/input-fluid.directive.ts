import { Directive } from '@angular/core';
import { InputComponent } from '../input.component';

@Directive({
  selector: 'app-input[appInputFluid]'
})
export class InputFluidDirective {

  constructor(
    private component: InputComponent
  ) {
    this.component.fluid = true;
  }

}
