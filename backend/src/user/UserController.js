const AbstractController = require('../util/AbstractController');
const UserRepository = require('./UserRepository');

class UserController extends AbstractController {
    #userRepository;

    constructor(app, database) {
        super(app);
        this.#userRepository = new UserRepository(database);
    }

    init() {
        this.app.get('/api/user', this.findAll);
        this.app.post('/api/user', this.createUser);
        this.app.post('/api/user/validate', this.validateUser);
    }

    findAll = async (req, res) => res.json(await this.#userRepository.findAll());
    createUser = async (req, res) => {
        req.body.role = {id: 1};
        return res.json(await this.#userRepository.create(req.body));
    }
    validateUser = async (req, res) => res.json(await this.#userRepository.existsByField(req.query.field, req.body[req.query.field]));
}

module.exports = UserController;