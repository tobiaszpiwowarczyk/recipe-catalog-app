const AbstractController =          require("../../util/AbstractController");
const RecipeRatingRepository =      require("./RecipeRatingRepository");
const LoginUtils =                  require("../../login/LoginUtils");
const UserRepository =              require("../../user/UserRepository");

class RecipeRatingController extends AbstractController {
    #recipeRatingRepository;
    #userRepository;

    constructor(app, database) {
        super(app);
        this.#recipeRatingRepository = new RecipeRatingRepository(database);
        this.#userRepository = new UserRepository(database);
    }

    init() {
        this.app.get("/api/recipe/rating/:recipeId", LoginUtils.requireAuthentication, this.findRatingByUserIdAndRecipeId);
        this.app.put("/api/recipe/rating", LoginUtils.requireAuthentication, this.updateRating);
        this.app.post("/api/recipe/rating", LoginUtils.requireAuthentication, this.createRating);
    }

    findRatingByUserIdAndRecipeId = async (req, res) => {
        var user = (await this.#userRepository.findByUsername(req.user.username));
        var rating = (await this.#recipeRatingRepository.findRatingByUserIdAndRecipeId(user.id, req.params.recipeId));

        if (rating == null)
            res.sendStatus(204);
        else {
            return res.json(rating);
        }
    }

    updateRating = async (req, res) => {
        var result = (await this.#recipeRatingRepository.updateRating(req.body));
        return res.json(await this.#recipeRatingRepository.findRatingByUserIdAndRecipeId(result.userId, result.recipeId));
    }

    createRating = async (req, res) => {
        var user = (await this.#userRepository.findByUsername(req.user.username));
        var result = (await this.#recipeRatingRepository.create({
            recipe: {
                id: req.body.recipe.id
            },
            user: {
                id: user.id
            },
            value: req.body.value
        }));
        return res.json(await this.#recipeRatingRepository.findRatingByUserIdAndRecipeId(result.userId, result.recipeId));
    }
}

module.exports = RecipeRatingController;