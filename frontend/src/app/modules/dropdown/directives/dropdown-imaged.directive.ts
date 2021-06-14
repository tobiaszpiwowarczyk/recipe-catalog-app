import { Directive } from '@angular/core';
import { DropdownComponent } from '../dropdown/dropdown.component';

@Directive({
  selector: '[appDropdownImaged]'
})
export class DropdownImagedDirective {

  constructor(
    private component: DropdownComponent
  ) {
    this.component.imaged = true;
  }

}
