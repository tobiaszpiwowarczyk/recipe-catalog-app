import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { SliderComponent } from './slider.component';
import { FormsModule } from '@angular/forms';
import { SliderTriggerOnMouseleaveDirective } from './directives/slider-update-on-mouseleave.directive';



@NgModule({
  declarations: [SliderComponent, SliderTriggerOnMouseleaveDirective],
  imports: [
    CommonModule,
    FormsModule
  ],
  exports: [SliderComponent, SliderTriggerOnMouseleaveDirective]
})
export class SliderModule { }
