import { Component, forwardRef, HostListener, Input, OnInit } from '@angular/core';
import { ControlValueAccessor, FormControl, NG_VALUE_ACCESSOR } from '@angular/forms';

@Component({
  selector: 'app-slider',
  templateUrl: './slider.component.html',
  styleUrls: ['./slider.component.scss'],
  providers: [
    {provide: NG_VALUE_ACCESSOR, useExisting: forwardRef(() => SliderComponent), multi: true}
  ]
})
export class SliderComponent implements OnInit, ControlValueAccessor {

  triggerOnMouseLeave: boolean = false;
  mousePressed: boolean = false;

  @Input() labelText: string = "";
  @Input() min: number = 1;
  @Input() max: number = 5;
  @Input() value: number = 1;
  @Input() control: FormControl;

  constructor() { }

  ngOnInit() {
  }

  propagateChange = (_:any) => {}

  change(value: number): void {
    if (this.triggerOnMouseLeave) {
      if (!this.mousePressed)
        this.propagateChange(this.value);
    }
    else {
      this.propagateChange(this.value);
    }
    this.value = value;
  }

  writeValue(value: number): void { this.value = value; }
  registerOnChange = (fn: any): void => this.propagateChange = fn;
  registerOnTouched(fn: any): void {}
  setDisabledState?(isDisabled: boolean): void {}


  @HostListener("window:mousedown", ["$event"])
  @HostListener("window:mouseup", ["$event"])
  private detectMousePressed(evt): void {
    this.mousePressed = evt.type == "mousedown";
  }
}