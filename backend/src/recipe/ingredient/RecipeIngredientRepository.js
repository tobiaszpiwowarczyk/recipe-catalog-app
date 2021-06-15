const AbstractRepository = require("../../util/AbstractRepository");

class RecipeIngredientRepository extends AbstractRepository {
    constructor(pool) {
        super(pool, "recipe_ingredients");
    }

    getFieldMapping = () => new Object({ "recipe": "recipe_id" });
    getValueMapping = (obj) => new Object({ "recipe": obj.recipe.id });
}

module.exports = RecipeIngredientRepository;