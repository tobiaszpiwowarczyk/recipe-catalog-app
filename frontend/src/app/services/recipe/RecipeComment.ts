import { User } from "../user/User";
import { Recipe } from "./Recipe";

export class RecipeComment {
    id?: number;
    recipe?: Recipe;
    content: string;
    likes: number;
    dislikes: number;
    createdDate: Date;
    user?: User;
    
    constructor(values: Object = {}) {
        Object.assign(this, values);
    }
}