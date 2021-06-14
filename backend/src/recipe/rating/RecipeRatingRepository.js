const AbstractRepository = require("../../util/AbstractRepository");

class RecipeRatingRepository extends AbstractRepository {
    constructor(pool) {
        super(pool, "recipe_rating");
    }

    getFieldMapping = () => new Object({ "recipe": "recipe_id", "user": "user_id" });
    getValueMapping = (obj) => new Object({ "recipe": obj.recipe.id, "user": obj.user.id, "createdDate": "" });
    

    async findRatingByUserIdAndRecipeId(userId, recipeId) {
        var result = (await this.pool.query(`
                SELECT
                      rr.id
                    , rr.value
                    , (
                        SELECT
                            json_build_object(
                                'rating', COALESCE(ROUND(AVG(rr2.value), 2), 0),
                                'rating_ammount', count(rr2.*)
                            )
                        FROM recipe_rating rr2
                        WHERE rr2.recipe_id = rr.recipe_id
                      ) as recipe
                FROM recipe_rating rr
                JOIN recipe r on rr.recipe_id = r.id
                WHERE rr.recipe_id = ${recipeId}
                  AND rr.user_id = ${userId}
            `)).rows;
        return result.length == 0 ? null : this.prepareFields(result[0]);
    }

    async updateRating(rating) {
        return this.prepareFields(
            (await this.pool.query(`
                UPDATE ${this.tableName}
                SET value = ${rating.value}
                WHERE id = ${rating.id}
                RETURNING *
            `)).rows[0]
        );
    }
}

module.exports = RecipeRatingRepository;