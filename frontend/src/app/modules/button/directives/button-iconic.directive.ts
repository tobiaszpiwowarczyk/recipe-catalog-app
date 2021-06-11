import { Directive, Input, OnInit } from '@angular/core';
import { ButtonComponent } from '../components/button/button.component';

@Directive({
  selector: 'app-button[appButtonIconic]'
})
export class ButtonIconicDirective implements OnInit {

  @Input("appButtonIconic") name: string = "";

  constructor(
    private component: ButtonComponent
  ) {
    this.component.iconic = true;
  }


  ngOnInit(): void {
    this.component.iconName = this.name;
  }

}
