import { Component, Input } from '@angular/core';
import { loadingSpinnerShowAnimation, loadingSpinnerWidgetAnimation } from './util/loading-spinner-animations';

@Component({
  selector: 'app-loading-spinner',
  templateUrl: './loading-spinner.component.html',
  styleUrls: ['./loading-spinner.component.scss'],
  animations: [loadingSpinnerShowAnimation, loadingSpinnerWidgetAnimation]
})
export class LoadingSpinnerComponent {

  @Input() shown: boolean = false;

  constructor() { }


  show = (): void => {this.shown = true;}
  hide = (): void => {this.shown = false;}
}
