const UserRepository        = require("../user/UserRepository");
const AbstractController    = require("../util/AbstractController");
const LoginUtils            = require('./LoginUtils');
const jwt                   = require('jsonwebtoken');

class LoginController extends AbstractController {
    #userRepository;
    #accessTokens;

    constructor(app, database) {
        super(app);
        this.#userRepository = new UserRepository(database);
        this.#accessTokens = [];
    }

    init() {
        this.app.post('/api/login/validate', this.validateUser);
        this.app.post('/api/login', this.login);
        this.app.get('/api/login', LoginUtils.requireAuthentication, this.getLoggedUser);
        this.app.delete('/api/login', LoginUtils.requireAuthentication, this.logout);
    }

    validateUser = async (req, res) => 
        res.json(await this.#userRepository.existsByUsernameAndPassword(req.body.username, req.body.password));

    login = (req, res) => {
        var accessToken = jwt.sign({ username: req.body.username }, "secret");
        this.#accessTokens.push(accessToken);

        return res.json({ accessToken: "Bearer " + accessToken });
    }

    getLoggedUser = async (req, res) => res.json(await this.#userRepository.findByUsername(req.user.username));

    logout = (req, res) => {
        this.#accessTokens = this.#accessTokens.filter(x => x != req.user.token);
        req.user = null;
        return res.json({logout: true});
    }
}

module.exports = LoginController;