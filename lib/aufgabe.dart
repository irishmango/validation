String? validateUsername(String? username) {
  if (username == null || username.trim().isEmpty) {
    return 'Username darf nicht leer sein';
  } else if (username.contains(' ')) {
    return 'Username darf keine Leerzeichen enthalten';
  } else if (username.length < 3) {
    return 'Username muss mindestens 3 Zeichen lang sein';
  }
  return null;
}


String? validateEmail(String email) {
  if (email.trim().isEmpty) {
    return 'Email darf nicht leer sein';
  }
  if (!email.contains('@') || !email.contains('.')) {
    return 'Email muss "@" und "." enthalten';
  }

  int atIndex = email.indexOf('@');
  int dotIndex = email.lastIndexOf('.');

  if (atIndex <= 0 || dotIndex < atIndex + 2 || dotIndex >= email.length - 1) {
    return 'Ungültiges Email-Format';
  }
  return null;
}


String? validatePassword(String password) {
  if (password.isEmpty) {
    return 'Passwort darf nicht leer sein';
  }
  if (password.length < 6) {
    return 'Passwort muss mindestens 6 Zeichen lang sein';
  }

  bool hasDigit = false;

  for (int i = 0; i < password.length; i++) {
    if ('0123456789'.contains(password[i])) {
      hasDigit = true;
      break;
    }
  }
  if (!hasDigit) {
    return 'Passwort muss mindestens eine Ziffer enthalten';
  }
  return null;
}
