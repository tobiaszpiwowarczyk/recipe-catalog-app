import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { DropdownComponent } from './dropdown/dropdown.component';
import { DropdownItemComponent } from './dropdown-item/dropdown-item.component';
import { DropdownImagedDirective } from './directives/dropdown-imaged.directive';
import { DropdownFluidDirective } from './directives/dropdown-fluid.directive';
import { FormsModule } from '@angular/forms';


const components = [
  DropdownComponent, DropdownItemComponent, DropdownImagedDirective, DropdownFluidDirective
];

@NgModule({
  declarations: components,
  imports: [CommonModule, FormsModule],
  exports: components
})
export class DropdownModule { }
