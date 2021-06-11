import { Component, Input, OnInit } from '@angular/core';

@Component({
  selector: 'app-loading-spinner',
  templateUrl: './loading-spinner.component.html',
  styleUrls: ['./loading-spinner.component.scss']
})
export class LoadingSpinnerComponent {

  @Input() shown: boolean = false;

  constructor() { }


  show = (): void => {this.shown = true;}
  hide = (): void => {this.shown = false;}
}
