import { RecipeCatalog } from "../recipe-catalog/RecipeCatalog";
import { User } from "../user/User";
import { RecipeComment } from "./RecipeComment";
import { RecipeIngredient } from "./RecipeIngredient";

export class Recipe {
    id: number;
    user: User;
    catalog: RecipeCatalog;
    name: string;
    imagePath: string;
    description: string;
    createdDate: Date;
    levelOfDifficulty: number;
    creationTime: number;
    commentsCount: number;
    rating: number;
    ratingCount: number;
    ingredients: RecipeIngredient[];
    comments: RecipeComment[];

    constructor(values: Object = {}) {
        Object.assign(this, values);
    }
}