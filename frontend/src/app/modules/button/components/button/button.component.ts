import { Component, Input, Output } from '@angular/core';

@Component({
  selector: 'app-button',
  templateUrl: './button.component.html',
  styleUrls: ['./button.component.scss']
})
export class ButtonComponent {

  iconic: boolean = false;
  iconName: string = "";
  fluid: boolean = false;
  negative: boolean = false;

  @Input() text: string = "";
  @Input() type: string = "button";
  @Input() disabled: boolean = false;

  constructor() { }
}
