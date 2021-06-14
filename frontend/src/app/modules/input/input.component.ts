import { Component, ElementRef, forwardRef, Input, OnInit } from '@angular/core';
import { ControlValueAccessor, FormControl, NG_VALUE_ACCESSOR } from '@angular/forms';
import { ErrorMessage } from './validator/ErrorMessage';
import { ErrorMessageFactory } from './validator/ErrorMessageFactory';

@Component({
  selector: 'app-input',
  templateUrl: './input.component.html',
  styleUrls: ['./input.component.scss'],
  providers: [
    { provide: NG_VALUE_ACCESSOR, useExisting: forwardRef(() => InputComponent), multi: true }
  ]
})
export class InputComponent implements OnInit, ControlValueAccessor {

  private errorMessageFactory: ErrorMessageFactory;

  focused: boolean = false;
  fluid: boolean = false;
  disabled: boolean = false;
  errorMessage: ErrorMessage;
  loadingIndicatorShown: boolean = false;

  @Input() placeholder: string = "";
  @Input() icon: string = "";
  @Input() type: string = "text";
  @Input() value: string = "";
  @Input() control: FormControl;
  @Input() showValidState: boolean = true;


  constructor(
    private _el: ElementRef
  ) {
    this.errorMessageFactory = new ErrorMessageFactory();
  }

  ngOnInit(): void {
    if (this.control != null) {
      this.control.statusChanges.subscribe(res => {
        this.loadingIndicatorShown = res == "PENDING";

        if (res == "INVALID")
          this.errorMessage = this.errorMessageFactory.getErrorMessage(this.control.errors);
      });
    }
  }




  propagateOnChange = (_:any) => {};


  public focus(): void {
    this.focused = true;
    this._el.nativeElement.querySelector("input").focus();
  }

  public blur(): void {
    this.focused = false;
    this._el.nativeElement.querySelector("input").blur();
  }

  public change(value: string): void {
    this.value = value;
    this.propagateOnChange(value);
    if (this.control.errors != null) {
      this.errorMessage = this.errorMessageFactory.getErrorMessage(this.control.errors);
    }
  }



  writeValue = (value: string): void => { this.value = value; }
  registerOnChange = (fn: any): void => this.propagateOnChange = fn;
  registerOnTouched = (_: any): void => {}
  setDisabledState? = (disabled: boolean): void => { this.disabled = disabled; }
}
