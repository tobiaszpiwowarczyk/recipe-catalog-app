const AbstractController =          require("../../util/AbstractController");
const RecipeCommentRepository =     require("./RecipeCommentRepository");
const LoginUtils =                  require("../../login/LoginUtils");
const UserRepository =              require("../../user/UserRepository");

class RecipeCommentController extends AbstractController {
    #recipeCommentRepository;
    #userRepository;

    constructor(app, database) {
        super(app);
        this.#recipeCommentRepository = new RecipeCommentRepository(database);
        this.#userRepository = new UserRepository(database);
    }

    init() {
        this.app.post("/api/recipe/comment", LoginUtils.requireAuthentication, this.createComment);
    }

    createComment = async (req, res) => {
        req.body.user = (await this.#userRepository.findByUsername(req.user.username));

        var comment = (await this.#recipeCommentRepository.create(req.body));
        comment.user = {
            firstName: req.body.user.firstName,
            lastName: req.body.user.lastName
        };

        delete comment.userId;

        return res.json(comment);
    };
}

module.exports = RecipeCommentController;