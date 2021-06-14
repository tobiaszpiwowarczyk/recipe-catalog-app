const AbstractRepository = require("../../util/AbstractRepository");

class RecipeCommentRepository extends AbstractRepository {
    constructor(pool) {
        super(pool, "recipe_comment");
    }

    getFieldMapping = () => new Object({ "recipe": "recipe_id", "user": "user_id" });

    getValueMapping = (obj) => new Object({ "recipe": obj.recipe.id, "user": obj.user.id, "createdDate": "" });
}

module.exports = RecipeCommentRepository;