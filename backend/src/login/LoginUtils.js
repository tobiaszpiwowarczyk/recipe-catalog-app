const jwt = require('jsonwebtoken');

class LoginUtils {
    static requireAuthentication(req, res, next) {
        var authHeader = req.headers['authorization'];
        var token = authHeader && authHeader.split(' ')[1];

        if (token == null) res.sendStatus(401);

        jwt.verify(token, "secret", (err, user) => {
            if (err) res.sendStatus(403);
            req.user = user;
            req.user.token = token;

            next();
        });
    }
}

module.exports = LoginUtils;