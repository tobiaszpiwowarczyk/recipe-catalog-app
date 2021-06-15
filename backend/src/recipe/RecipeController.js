const AbstractController            = require("./../util/AbstractController");
const RecipeRepository              = require("./RecipeRepository");
const LoginUtils                    = require("./../login/LoginUtils");
const UserRepository                = require("./../user/UserRepository");
const RecipeIngredientRepository    = require("./ingredient/RecipeIngredientRepository");

class RecipeController extends AbstractController {
    #recipeRepository;
    #userRepository;
    #recipeIngredientRepository;

    constructor(app, database) {
        super(app);
        this.#recipeRepository = new RecipeRepository(database);
        this.#userRepository = new UserRepository(database);
        this.#recipeIngredientRepository = new RecipeIngredientRepository(database);
    }

    init() {
        this.app.post("/api/recipe/filter", this.findFilteredRecipes);
        this.app.post("/api/recipe", LoginUtils.requireAuthentication, this.createRecipe);
        this.app.get("/api/recipe/:id", this.findById);
        this.app.put("/api/recipe", LoginUtils.requireAuthentication, this.updateRecipe);
        this.app.delete("/api/recipe/:id", LoginUtils.requireAuthentication, this.removeRecipe);
    }

    findFilteredRecipes = async (req, res) => res.json(await this.#recipeRepository.findFilteredRecipes(req.body));
    findById = async (req, res) => {
        var result = (await this.#recipeRepository.findById(req.params.id));
                
        if(result == null)
            res.sendStatus(404);
        else
            return res.json(result);
    };

    createRecipe = async (req, res) => {
        var user = (await this.#userRepository.findByUsername(req.user.username));
        req.body.user = {
            id: user.id
        };

        var recipe = (await this.#recipeRepository.create(req.body));

        req.body.ingredients.forEach(async ingredient => {
            ingredient["recipe"] = {
                id: recipe.id
            };
            (await this.#recipeIngredientRepository.create(ingredient));
        });

        return res.json({created: true});
    }

    updateRecipe = async (req, res) => {
        var user = (await this.#userRepository.findByUsername(req.user.username));
        req.body.user = {
            id: user.id
        };

        var result = (await this.#recipeRepository.updateRecipe(req.body));

        (await this.#recipeIngredientRepository.deleteByField("recipeId", req.body.id));

        req.body.ingredients.forEach(ingredient => {
            ingredient["recipe"] = {
                id: ingredient.recipeId
            };

            delete ingredient.recipeId;
            this.#recipeIngredientRepository.create(ingredient);
        })

        return res.json({ updated: result});
    }

    removeRecipe = async (req, res) => res.json({ removed: (await this.#recipeRepository.deleteByField("id", req.params.id)) });
}

module.exports = RecipeController;