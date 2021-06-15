import { Recipe } from "./Recipe";

export class RecipeIngredient {
    id: number;
    name: string;
    recipe: Recipe;

    constructor(values: Object = {}) {
        Object.assign(this, values);
    }
}