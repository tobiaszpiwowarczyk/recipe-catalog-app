import { AfterViewInit, Directive, OnInit } from '@angular/core';
import { InputComponent } from '../input.component';

@Directive({
  selector: 'app-input[appInputAutofocus]'
})
export class InputAutofocusDirective implements OnInit {

  constructor(
    private component: InputComponent
  ) {}

  ngOnInit(): void {
    this.component.focus();
  }
}
