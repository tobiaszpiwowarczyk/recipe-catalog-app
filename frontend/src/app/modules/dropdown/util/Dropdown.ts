import { DropdownItem } from "./DropdownItem";

export class Dropdown {
    imaged: boolean;
    selectedItem?: DropdownItem;
    items: DropdownItem[];

    constructor(values: Object = {}) {
        Object.assign(this, values);
    }
}