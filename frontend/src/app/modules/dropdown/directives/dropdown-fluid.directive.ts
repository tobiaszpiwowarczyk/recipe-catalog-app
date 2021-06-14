import { Directive } from '@angular/core';
import { DropdownComponent } from '../dropdown/dropdown.component';

@Directive({
  selector: '[appDropdownFluid]'
})
export class DropdownFluidDirective {

  constructor(
    private component: DropdownComponent
  ) {
    this.component.fluid = true;
  }

}
