import { Injectable } from '@angular/core';
import { BehaviorSubject } from 'rxjs';
import { Dropdown } from '../util/Dropdown';

@Injectable()
export class DropdownService {

  dropdownData: BehaviorSubject<Dropdown> = new BehaviorSubject<Dropdown>(new Dropdown());

  setDropdownData = (data: Dropdown): void => this.dropdownData.next(data);
}
