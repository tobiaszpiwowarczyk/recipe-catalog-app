const express                   = require("express");
const app                       = express();
const database                  = require("./config/database");
const UserController            = require("./user/UserController");
const LoginController           = require("./login/LoginController");
const RecipeCatalogController   = require("./recipe/catalog/RecipeCatalogController");
const RecipeContontroller       = require("./recipe/RecipeController");
const RecipeCommentController   = require("./recipe/comment/RecipeCommentController");
const RecipeRatingController    = require("./recipe/rating/RecipeRatingController");

app.use(express.json());
app.listen(3000, () => console.log("Aplikacja serwerowa działa na porcie 3000"));

var controllers = [
    new UserController(app, database),
    new LoginController(app, database),
    new RecipeCatalogController(app, database),
    new RecipeContontroller(app, database),
    new RecipeCommentController(app, database),
    new RecipeRatingController(app, database)
];
controllers.forEach(controller => controller.init());