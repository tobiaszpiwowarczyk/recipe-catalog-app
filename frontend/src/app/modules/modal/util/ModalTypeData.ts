export class ModalTypeData {
    name: string;
    icon: string;
    title: string;

    constructor(values: Object = {}) {
        Object.assign(this, values);
    }
}