import { Component, Input, Output } from '@angular/core';

@Component({
  selector: 'app-button',
  templateUrl: './button.component.html',
  styleUrls: ['./button.component.scss']
})
export class ButtonComponent {

  iconic: boolean = false;
  iconName: string = "";

  @Input() text: string = "";
  @Input() disabled: boolean = false;

  constructor() { }
}
