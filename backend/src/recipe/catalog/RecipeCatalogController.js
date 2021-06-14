const AbstractController = require("../../util/AbstractController");
const RecipeCatalogRepository = require("./RecipeCatalogRepository");

class RecipeCatalogController extends AbstractController {
    #recipeCatalogRepository;

    constructor(app, database) {
        super(app);
        this.#recipeCatalogRepository = new RecipeCatalogRepository(database);
    }

    init() {
        this.app.get("/api/recipe/catalog", this.findAll);
        this.app.get("/api/recipe/catalog/:id", this.findById);
    }

    findAll = async (req, res) => res.json(await this.#recipeCatalogRepository.findAll());
    findById = async (req, res) => res.json(await this.#recipeCatalogRepository.findByField("id", req.params.id));
    
}

module.exports = RecipeCatalogController;