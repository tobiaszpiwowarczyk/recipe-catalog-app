export class RecipeFilterData {
    catalogId: number;
    authorId: number;
    maxLevelOfDifficulty: number;

    constructor(values: Object = {}) {
        Object.assign(this, values);
    }
}