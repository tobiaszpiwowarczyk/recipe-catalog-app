const Pool = require('pg').Pool;

module.exports = new Pool({
  user: "postgres",
  password: process.env.POSTGRES_PASSWORD || "password#123",
  database: process.env.POSTGRES_DB || "recipe_catalog_app",
  host: process.env.POSTGRES_HOSTNAME || "database",
  port: 5432
});