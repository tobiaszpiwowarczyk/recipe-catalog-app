export class DropdownItem {
    id: number;
    content: string;
    image: string;
    additionalData: object;

    constructor(values: Object = {}) {
        Object.assign(this, values);
    }
}