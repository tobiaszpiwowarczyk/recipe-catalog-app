import { Component, forwardRef, Input, OnInit } from '@angular/core';
import { ControlValueAccessor, FormControl, NG_VALUE_ACCESSOR } from '@angular/forms';
import { ErrorMessage } from '../input/validator/ErrorMessage';
import { ErrorMessageFactory } from '../input/validator/ErrorMessageFactory';

@Component({
  selector: 'app-textarea',
  templateUrl: './textarea.component.html',
  styleUrls: ['./textarea.component.scss'],
  providers: [
    {provide: NG_VALUE_ACCESSOR, useExisting: forwardRef(() => TextareaComponent), multi: true}
  ]
})
export class TextareaComponent implements OnInit, ControlValueAccessor {

  private errorMessageFactory: ErrorMessageFactory;

  focused: boolean = false;
  errorMessage: ErrorMessage;

  @Input() value: string = "";
  @Input() placeholder: string = "";
  @Input() width: number = 350;
  @Input() height: number = 60;
  @Input() control: FormControl;

  constructor() {
    this.errorMessageFactory = new ErrorMessageFactory();
  }

  ngOnInit() {
    if (this.control != null) {
      this.control.statusChanges.subscribe(res => {
        if (res == "INVALID")
          this.errorMessage = this.errorMessageFactory.getErrorMessage(this.control.errors);
      });
    }
  }

  propagateChange = (_:any) => {};

  public change(value: string): void {
    this.value = value;
    this.propagateChange(value);
    if (this.control.errors != null) {
      this.errorMessage = this.errorMessageFactory.getErrorMessage(this.control.errors);
    }
  }

  writeValue(value: string): void { this.value = value; }
  registerOnChange = (fn: any): void => this.propagateChange = fn;
  registerOnTouched(fn: any): void {}
  setDisabledState?(isDisabled: boolean): void { }

}