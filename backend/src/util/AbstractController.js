class AbstractController {
    app;

    constructor(app) {
        this.app = app;
    }

    init() {
        throw new Error("Musisz zaimplementować metodę init()");
    }
}

module.exports = AbstractController;