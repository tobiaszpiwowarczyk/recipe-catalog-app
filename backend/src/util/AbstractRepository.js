const ValueUtils = require('./ValueUtils');

class AbstractRepository {
  pool;
  tableName;

  constructor(pool, tableName) {
    this.pool = pool;
    this.tableName = tableName;
  }

  getDatabaseFields(object) {
    return Object.keys(object)
            .filter(x => x != "id" && typeof object[x] != "function" && this.getValueMapping(object)[x] != "")
            .map(key => this.getFieldMapping()[key] || key)
            .map(key => ValueUtils.toKebabCase(key))
            .join(', ')
  }

  getDatabaseValues(object) {
    return Object.keys(object)
            .filter(x => x != "id" && typeof object[x] != "function" && this.getValueMapping(object)[x] != "")
            .map(x => {
              var mapping = this.getValueMapping(object)[x];
              var value = mapping || object[x];

              return ValueUtils.addQuotes(value);
            })
            .join(', ')
  }

  prepareFields = object => {
    var res = {};
    Object.keys(object).forEach(x => {
      if (Array.isArray(object[x])) {
        res[ValueUtils.toCamelCase(x)] = object[x].map(y => this.prepareFields(y));
      }
      else {
        res[ValueUtils.toCamelCase(x)] = typeof object[x] == "object" && !(object[x] instanceof Date) ? this.prepareFields(object[x]) : object[x];
      }
    });
    return res;
  }

  getFieldMapping = () => new Object({});
  getValueMapping = (obj) => new Object({});

  findAll = async () => (await this.pool.query("SELECT * FROM " + this.tableName)).rows.map(x => this.prepareFields(x));

  create = async (object) => this.prepareFields((await this.pool.query(`INSERT INTO ${this.tableName}(${this.getDatabaseFields(object)}) VALUES (${this.getDatabaseValues(object)}) RETURNING *`)).rows[0]);

  existsByField = async (fieldName, value) => 
    (await this.pool.query(`SELECT EXISTS(SELECT * FROM ${this.tableName} WHERE ${ValueUtils.toKebabCase(fieldName)} = ${ValueUtils.addQuotes(value)})`)).rows[0];

  findByField = async (fieldName, value) =>
    this.prepareFields((await this.pool.query(`SELECT * FROM ${this.tableName} WHERE ${ValueUtils.toKebabCase(fieldName)} = ${ValueUtils.addQuotes(value)}`)).rows[0]);
}

module.exports = AbstractRepository;