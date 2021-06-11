class ValueUtils {
    static addQuotes = value => typeof value == 'string' ? `'${value}'` : value;

    static toKebabCase = value => value.replace(/([A-Z])/g, "_$1").toLowerCase();

    static toCamelCase = value => {
        if (/\_[a-z]/g.test(value))
            value.match(/\_[a-z]/g).forEach(x => value = value.replace(x, x.substring(1).toUpperCase()));
        return value;
    }
}

module.exports = ValueUtils;