import { Recipe } from "src/app/services/recipe/Recipe";

export class RecipeRating {
    id: number;
    recipe: Recipe;
    value: number;

    constructor(values: Object = {}) {
        Object.assign(this, values);
    }
}