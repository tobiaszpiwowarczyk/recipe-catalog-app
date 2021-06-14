import { Component, forwardRef, Input, OnInit } from '@angular/core';
import { ControlValueAccessor, FormControl, NG_VALUE_ACCESSOR } from '@angular/forms';

@Component({
  selector: 'app-rating',
  templateUrl: './rating.component.html',
  styleUrls: ['./rating.component.scss'],
  providers: [
    {provide: NG_VALUE_ACCESSOR, useExisting: forwardRef(() => RatingComponent), multi: true}
  ]
})
export class RatingComponent implements OnInit, ControlValueAccessor {

  data: any[] = [];
  disabled: boolean = false;

  @Input() value: number = 0;
  @Input() control: FormControl;

  constructor() { }

  propagateChange = (_:any) => {}

  ngOnInit() {

    if (this.value < 0 || this.value > 5)
      throw new Error("Wartość musi być z przedziału od 0 do 5");

    for(var i = 0; i < 5; i++) {
      this.data.push({
        index: i,
        hovered: false,
        applied: this.value > i
      });
    }
  }



  highlightStar(index: number, hovered: boolean): void {
    for(var i = 0; i <= index; i++) {
      this.data[i].hovered = hovered;
    }
  }

  applyRating(index: number): void {
    this.data.forEach(x => x.applied = false);
    for(var i = 0; i <= index; i++)
      this.data[i].applied = true;
    this.value = index + 1;
    this.propagateChange(this.value);
  }


  writeValue(value: number): void { 
    this.data.forEach(x => x.applied = false);
    for (var i = 0; i < value; i++)
      this.data[i].applied = true;
    this.value = value;
  }
  registerOnChange = (fn: any): void => this.propagateChange = fn;
  registerOnTouched(fn: any): void { }
  setDisabledState?(isDisabled: boolean): void { this.disabled = isDisabled; }
}