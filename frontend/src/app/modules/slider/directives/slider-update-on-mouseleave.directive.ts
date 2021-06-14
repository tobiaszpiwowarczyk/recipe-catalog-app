import { Directive } from '@angular/core';
import { SliderComponent } from '../slider.component';

@Directive({
  selector: 'app-slider[appSliderTriggerOnMouseleave]'
})
export class SliderTriggerOnMouseleaveDirective {

  constructor(
    private component: SliderComponent
  ) {
    this.component.triggerOnMouseLeave = true;
  }

}
