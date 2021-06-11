export class ErrorMessage {
    name: string;
    message: string;
    
    constructor(values: Object = {}) {
        Object.assign(this, values);
    }
}