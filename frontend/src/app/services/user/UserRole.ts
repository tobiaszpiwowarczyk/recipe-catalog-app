export class UserRole {
    id: number;
    name: string;

    constructor(values: object) {
        Object.assign(this, values);
    }
}