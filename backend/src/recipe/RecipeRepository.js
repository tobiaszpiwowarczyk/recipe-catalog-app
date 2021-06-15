const AbstractRepository = require("./../util/AbstractRepository");

class RecipeRepository extends AbstractRepository {
    constructor(pool) {
        super(pool, "recipe");
    }

    getFieldMapping = () => new Object({ "user": "user_id", "catalog": "catalog_id" });
    getValueMapping = (obj) => new Object({ "user": obj.user.id, "catalog": obj.catalog.id, "createdDate": "", "ingredients": "" });

    async findFilteredRecipes(filterData) {
        return (await this.pool.query(`
            SELECT
                  r.id
                , r.name
                , r.image_path
                , r.created_date
                , r.level_of_difficulty
                , r.creation_time
                , json_build_object(
                    'firstName', u.first_name,
                    'lastName', u.last_name
                ) as user
                , COALESCE(ROUND(AVG(DISTINCT rr.value), 2), 0) as rating
                , COUNT(DISTINCT rc.content) as comment_count
                , COUNT(DISTINCT rr.*) as rating_count
            FROM recipe r
            JOIN users u on r.user_id = u.id
            LEFT OUTER JOIN recipe_rating rr on rr.recipe_id = r.id
            LEFT OUTER JOIN recipe_comment rc on rc.recipe_id = r.id
            WHERE r.catalog_id = ${filterData.catalogId}
              AND r.level_of_difficulty <= ${filterData.maxLevelOfDifficulty}
              ${filterData.authorId > 0 ? ('\nAND r.user_id = ' + filterData.authorId) : ''}
            GROUP BY  r.id
                    , u.first_name
                    , u.last_name
                    , r.name
                    , r.image_path
                    , r.created_date
                    , r.level_of_difficulty
                    , r.creation_time
            ORDER BY created_date DESC
        `)).rows.map(row => this.prepareFields(row));
    }


    async findById(id) {
        var res = (await this.pool.query(`
                SELECT
                      r.id
                    , r.name
                    , r.image_path
                    , r.description
                    , r.created_date
                    , r.level_of_difficulty
                    , r.creation_time
                    , json_build_object(
                        'firstName', first_name,
                        'lastName', last_name
                    ) as user
                    , row_to_json(rc) as catalog
                    , jsonb_agg(distinct ri.*) as ingredients
                    , CASE
                        WHEN COUNT(distinct rcm."content") = 0 then '[]'
                        ELSE (
                            with comm_with_users
                            as
                            (
                                SELECT
                                    rc2.id
                                    , rc2.recipe_id
                                    , rc2."content"
                                    , rc2.likes
                                    , rc2.dislikes
                                    , rc2.created_date
                                    , json_build_object(
                                        'firstName', first_name,
                                        'lastName', last_name
                                    ) as user
                                FROM recipe_comment rc2
                                JOIN users u2 on rc2.user_id = u2.id
                            ),
                            comm_list
                            as
                            (
                                SELECT
                                    r3.id
                                    , CASE
                                        WHEN COUNT(DISTINCT cwu."content") = 0 then '[]'
                                        ELSE json_agg(DISTINCT cwu.*)
                                    END as "comments"
                                FROM recipe r3
                                LEFT OUTER JOIN comm_with_users cwu ON cwu.recipe_id = r3.id
                                WHERE r3.id = r.id
                                GROUP by r3.id
                            )
                            SELECT "comments" FROM comm_list
                        )
                      END as "comments"
                    , COUNT(DISTINCT rcm."content") as comments_count
                    , COALESCE(ROUND(AVG(DISTINCT rr.value), 2), 0) as rating
                    , COUNT(DISTINCT rr.*) as rating_count
                FROM recipe r
                JOIN users u ON r.user_id = u.id
                JOIN recipe_catalog rc ON r.catalog_id = rc.id
                JOIN recipe_ingredients ri ON ri.recipe_id = r.id
                LEFT OUTER JOIN recipe_rating rr ON rr.recipe_id = r.id
                LEFT OUTER JOIN recipe_comment rcm ON rcm.recipe_id = r.id
                WHERE r.id = ${id}
                GROUP by  r.id
                        , r.image_path
                        , r.description
                        , r.created_date
                        , r.level_of_difficulty
                        , r.creation_time
                        , u.first_name
                        , u.last_name
                        , rc.*
                ORDER BY r.id
            `)).rows[0];

        return res == null ? null : this.prepareFields(res);
    }


    async updateRecipe(recipe) {
        (await this.pool.query(`
            UPDATE ${this.tableName} 
               SET catalog_id = ${recipe.catalog.id},
                   name = '${recipe.name}',
                   image_path = '${recipe.imagePath}',
                   description = '${recipe.description}',
                   level_of_difficulty = ${recipe.levelOfDifficulty},
                   creation_time = ${recipe.creationTime}
             WHERE id = ${recipe.id}
        `));

        return true;
    }
}

module.exports = RecipeRepository;