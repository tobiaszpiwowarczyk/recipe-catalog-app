class User {
  id;
  role;
  username;
  password;
  firstName;
  lastName;
  emailAddress;
  createdDate;

  constructor(values) {
    Object.assign(this, values);
  }
}

module.exports = User;