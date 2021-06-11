import { UserRole } from "./UserRole";

export class User {
    id: number;
    role: UserRole;
    username: string;
    password: string;
    firstName: string;
    lastName: string;
    emailAddress: string;
    createdDate: Date;

    constructor(values: object) {
        Object.assign(this, values);
    }
}