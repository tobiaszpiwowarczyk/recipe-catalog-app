const AbstractRepository = require("../../util/AbstractRepository");

class RecipeCatalogRepository extends AbstractRepository {
    constructor(pool) {
        super(pool, "recipe_catalog");
    }
}

module.exports = RecipeCatalogRepository;