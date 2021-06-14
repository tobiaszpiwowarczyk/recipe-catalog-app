export class RecipeFilterData {
    catalogId: number;
    authorId: number;
    levelOfDifficulty: number;

    constructor(values: Object = {}) {
        Object.assign(this, values);
    }
}