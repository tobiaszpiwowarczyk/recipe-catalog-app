import { Component, HostListener, Input, OnInit } from '@angular/core';
import { DropdownService } from '../services/dropdown.service';
import { Dropdown } from '../util/Dropdown';
import { DropdownItem } from '../util/DropdownItem';

@Component({
  selector: 'app-dropdown-item',
  templateUrl: './dropdown-item.component.html',
  styleUrls: ['./dropdown-item.component.scss']
})
export class DropdownItemComponent implements OnInit {

  dropdownData: Dropdown;
  itemActive: boolean = false;

  @Input() data: DropdownItem;
  @Input() noBorder: boolean = false;

  constructor(
    private ds: DropdownService
  ) { }

  ngOnInit() {
    this.ds.dropdownData.subscribe(res => {
      this.dropdownData = res;
      this.itemActive = res.selectedItem == this.data;
    });
  }

  
  @HostListener("click")
  private setActiveElement() {
    this.dropdownData.selectedItem = this.data;
    this.ds.setDropdownData(this.dropdownData);
  }
}
