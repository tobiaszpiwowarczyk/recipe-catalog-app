const AbstractController = require("./../util/AbstractController");
const RecipeRepository = require("./RecipeRepository");

class RecipeController extends AbstractController {
    #recipeRepository;
    
    constructor(app, database) {
        super(app);
        this.#recipeRepository = new RecipeRepository(database);
    }

    init() {
        this.app.post("/api/recipe/filter", this.findFilteredRecipes);
        this.app.get("/api/recipe/:id", this.findById);
    }

    findFilteredRecipes = async (req, res) => res.json(await this.#recipeRepository.findFilteredRecipes(req.body));
    findById = async (req, res) => res.json(await this.#recipeRepository.findById(req.params.id));
}

module.exports = RecipeController;