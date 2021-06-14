import { Component, ElementRef, forwardRef, HostListener, Input, OnInit } from '@angular/core';
import { ControlValueAccessor, FormControl, NG_VALUE_ACCESSOR } from '@angular/forms';
import { ObjectUtils } from 'src/app/util/ObjectUtils';
import { DropdownService } from '../services/dropdown.service';
import { Dropdown } from '../util/Dropdown';
import { dropdownItemListAnimation } from '../util/dropdown-animations';
import { DropdownItem } from '../util/DropdownItem';

@Component({
  selector: 'app-dropdown',
  templateUrl: './dropdown.component.html',
  styleUrls: ['./dropdown.component.scss'],
  animations: [dropdownItemListAnimation],
  providers: [
    { provide: NG_VALUE_ACCESSOR, useExisting: forwardRef(() => DropdownComponent), multi: true },
    DropdownService
  ]
})
export class DropdownComponent implements OnInit, ControlValueAccessor {

  opened: boolean = false;
  imaged: boolean = false;
  fluid: boolean = false;
  dropdownData: Dropdown;

  @Input() labelText: string = "";
  @Input() items: DropdownItem[] = [];
  @Input() control: FormControl;

  constructor(
    private ds: DropdownService,
    private el: ElementRef
  ) { }

  propagateOnChange = (_: any) => { };

  
  ngOnInit(): void {
    if (this.items.length > 0) {
      this.dropdownData = {
        imaged: this.imaged,
        selectedItem: this.items[0],
        items: this.items
      };

      this.ds.setDropdownData(this.dropdownData);
    }

    this.ds.dropdownData.subscribe(res => {
      this.dropdownData = res;
      this.opened = false;
      if (!ObjectUtils.isEmpty(res))
        this.propagateOnChange(res.selectedItem);
    });
  }

  writeValue(obj: DropdownItem): void { this.dropdownData.selectedItem = obj; }
  registerOnChange = (fn: any): void => this.propagateOnChange = fn;
  registerOnTouched(fn: any): void {}
  setDisabledState?(isDisabled: boolean): void {}


  public selectItem(index: number): void {
    this.dropdownData.selectedItem = this.items[index];
    this.ds.setDropdownData(this.dropdownData);
  }

  public setItems(items: DropdownItem[]): void {
    this.items = items;

    this.dropdownData = {
      imaged: this.imaged,
      items: this.items
    };
  }


  @HostListener("window:click", ["$event"])
  private closeDropdown(evt): void {
    if (!this.el.nativeElement.contains(evt.target))
      this.opened = false;
  }
}
