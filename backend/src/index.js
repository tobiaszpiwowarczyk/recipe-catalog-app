const express         = require("express");
const app             = express();
const database        = require("./config/database");
const UserController  = require("./user/UserController");
const LoginController = require("./login/LoginController");

app.use(express.json());
app.listen(3000, () => console.log("Aplikacja serwerowa działa na porcie 3000"));

var controllers = [
    new UserController(app, database),
    new LoginController(app, database)
];
controllers.forEach(controller => controller.init());