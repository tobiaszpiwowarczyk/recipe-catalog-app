const AbstractRepository = require("../util/AbstractRepository");

class UserRepository extends AbstractRepository {
  constructor(pool) {
    super(pool, "users");
  }

  getFieldMapping = () => new Object({ "role": "role_id" });

  getValueMapping = (obj) => new Object({ "role": obj.role.id, "createdDate": "" });

  existsByUsernameAndPassword = async (username, password) =>
    (await this.pool.query(`SELECT EXISTS(SELECT * FROM users WHERE username = '${username}' AND password = '${password}')`)).rows[0];

  findByUsername = async (username) => {
    var res = this.prepareFields(
      (await this.pool.query(`
        SELECT u.id, role.id as role_id, role.name as role_name, username, password, first_name, last_name, email_address, created_date 
        FROM users u JOIN users_roles role ON u.role_id = role.id WHERE username = '${username}'
      `)).rows[0]
    );

    res.role = {
      id: res.roleId,
      name: res.roleName
    };

    delete res.roleId;
    delete res.roleName;

    return res;
  }

  findByRecipeCatalogId = async recipeCatalogId => {
    return (await this.pool.query(`
      SELECT
          -1 as id
        , 'Wszyscy' as first_name
        , 'Wszyscy' as last_name
      UNION
      SELECT
          u.id
        , u.first_name
        , u.last_name
      FROM users u
      JOIN recipe r on r.user_id = u.id
      WHERE r.catalog_id = ${recipeCatalogId}
      ORDER BY id
    `)).rows.map(x => this.prepareFields(x));
  }
}

module.exports = UserRepository;