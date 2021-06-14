export class RecipeCatalog {
    id: number;
    name: string;
    imageName: string;

    constructor(values: Object = {}) {
        Object.assign(this, values);
    }
}