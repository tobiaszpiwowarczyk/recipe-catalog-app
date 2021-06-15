export class ModalEvent {
    opened: boolean;
    approved: boolean;

    constructor(values: Object = {}) {
        Object.assign(this, values);
    }
}