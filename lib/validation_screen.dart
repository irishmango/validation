import 'package:flutter/material.dart';
import 'package:validation/confirmation_screen.dart';
import 'package:validation/app_user.dart';

class ValidationScreen extends StatefulWidget {
  const ValidationScreen({super.key});

  @override
  State<ValidationScreen> createState() => _ValidationScreenState();
}

class _ValidationScreenState extends State<ValidationScreen> {

  late AppUser user;


  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repeatPasswordController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  bool _isFormValid = false;

  final _usernameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _repeatPasswordFocus = FocusNode();

  bool _usernameTouched = false;
  bool _emailTouched = false;
  bool _passwordTouched = false;
  bool _repeatPasswordTouched = false;

  static const String abcLower = 'abcdefghijklmnopqrstuvwxyz';
  static const String abcUpper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  static const String numbers = '0123456789';
  static const String specialChars = '!@#\$%^&*()_-+=[]{}|;:,.<>?/~';

  @override
  void initState() {
    super.initState();

    _usernameFocus.addListener(() {
      if (!_usernameFocus.hasFocus) setState(() => _usernameTouched = true);
    });
    _emailFocus.addListener(() {
      if (!_emailFocus.hasFocus) setState(() => _emailTouched = true);
    });
    _passwordFocus.addListener(() {
      if (!_passwordFocus.hasFocus) setState(() => _passwordTouched = true);
    });
    _repeatPasswordFocus.addListener(() {
      if (_repeatPasswordFocus.hasFocus) {
        setState(() => _repeatPasswordTouched = true);
      }
    });

    _usernameController.addListener(_updateFormValidity);
    _emailController.addListener(_updateFormValidity);
    _passwordController.addListener(_updateFormValidity);
    _repeatPasswordController.addListener(_updateFormValidity);
  }

  @override
  void dispose() {
    _usernameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _repeatPasswordFocus.dispose();

    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  void _updateFormValidity() {
    final isValid = validateUsername(_usernameController.text) == null &&
        validateEmail(_emailController.text) == null &&
        validatePassword(_passwordController.text) == null &&
        validateRepeatPassword(_repeatPasswordController.text) == null;

    setState(() {
      _isFormValid = isValid;
    });
  }

  String? validateUsername(String? userInput) {
    if (userInput == null || userInput.isEmpty) {
      return "Username is required.";
    }
    if (userInput.length < 3) {
      return "Min. 3 characters";
    }
    if (userInput.length > 20) {
      return "Max. 20 characters";
    }
    if (userInput.contains(' ')) {
      return "No spaces allowed.";
    }
    return null;
  }

  String? validateEmail(String? email) {
  if (email == null || email.trim().isEmpty) {
    return "Email is required.";
  }

  email = email.trim();

  final atIndex = email.indexOf('@');
  final dotIndex = email.lastIndexOf('.');

  final hasAt = atIndex > 0;
  final hasDot = dotIndex > atIndex + 1 && dotIndex < email.length - 1;

  if (!hasAt || !hasDot) {
    return "Enter a valid email.";
  }

  return null;
}

  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return "Password is required.";
    }
    if (password.length < 6) {
      return "Must be at least 6 characters.";
    }
    if (!password.split('').any((t) => numbers.contains(t))) {
      return "Password must contain a number.";
    }
    if (!password.split('').any((t) => abcLower.contains(t))) {
      return "Password must contain a lowercase letter.";
    }
    if (!password.split('').any((t) => abcUpper.contains(t))) {
      return "Password must contain an uppercase letter.";
    }
    if (!password.split('').any((t) => specialChars.contains(t))) {
      return "Password must contain a special character.";
    }
    return null;
  }

  String? validateRepeatPassword(String? repeatPassword) {
    if (repeatPassword == null || repeatPassword.isEmpty) {
      return "Please repeat your password.";
    }
    if (repeatPassword != _passwordController.text) {
      return "Passwords do not match.";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Validation Screen"),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Center(
              child: Text(
                "Create a new account",
                style: TextStyle(fontSize: 36),
              ),
            ),
            const SizedBox(height: 20),
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    focusNode: _usernameFocus,
                    controller: _usernameController,
                    onChanged: (_) => _updateFormValidity(),
                    autovalidateMode: _usernameTouched
                        ? AutovalidateMode.onUserInteraction
                        : AutovalidateMode.disabled,
                    validator: validateUsername,
                    decoration: InputDecoration(
                      hintText: "Username",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    focusNode: _emailFocus,
                    controller: _emailController,
                    onChanged: (_) => _updateFormValidity(),
                    autovalidateMode: _emailTouched
                        ? AutovalidateMode.onUserInteraction
                        : AutovalidateMode.disabled,
                    validator: validateEmail,
                    decoration: InputDecoration(
                      hintText: "Email",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    focusNode: _passwordFocus,
                    controller: _passwordController,
                    obscureText: true,
                    onChanged: (_) => _updateFormValidity(),
                    autovalidateMode: _passwordTouched
                        ? AutovalidateMode.onUserInteraction
                        : AutovalidateMode.disabled,
                    validator: validatePassword,
                    decoration: InputDecoration(
                      hintText: "Password",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  AnimatedBuilder(
                    animation: _passwordController,
                    builder: (context, _) {
                      final password = _passwordController.text;
                      return validatePassword(password) == null
                          ? const SizedBox.shrink()
                          : PasswordRequirements(password: password);
                    },
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    focusNode: _repeatPasswordFocus,
                    controller: _repeatPasswordController,
                    obscureText: true,
                    onChanged: (_) => _updateFormValidity(),
                    autovalidateMode: _repeatPasswordTouched
                        ? AutovalidateMode.onUserInteraction
                        : AutovalidateMode.disabled,
                    validator: validateRepeatPassword,
                    decoration: InputDecoration(
                      hintText: "Repeat Password",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _isFormValid
              ? () {
                  setState(() {
                    user = AppUser(
                      username: _usernameController.text.trim(),
                      email: _emailController.text.trim(),
                      password: _passwordController.text.trim(),
                    );
                  });

                  debugPrint('Collected user data: ${user.userData}');

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => ConfirmationScreen(),
                    ),
                  );
                }
              : null,
              style: FilledButton.styleFrom(
                backgroundColor: _isFormValid
                    ? Color.fromRGBO(47, 93, 1, 1)
                    : Colors.grey,
              ),
              child: const Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}







class PasswordRequirements extends StatelessWidget {
  final String password;
  const PasswordRequirements({required this.password, super.key});

  @override
  Widget build(BuildContext context) {
    final hasMinLength = password.length >= 6;
    final hasDigit = password.split('').any((char) => _ValidationScreenState.numbers.contains(char));
    final hasUpper = password.split('').any((char) => _ValidationScreenState.abcUpper.contains(char));
    final hasLower = password.split('').any((char) => _ValidationScreenState.abcLower.contains(char));
    final hasSpecial = password.split('').any((char) => _ValidationScreenState.specialChars.contains(char));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RequirementRow(fulfilled: hasMinLength, requirement: 'At least 6 characters'),
        RequirementRow(fulfilled: hasDigit, requirement: 'Contains at least one digit'),
        RequirementRow(fulfilled: hasUpper, requirement: 'Contains an uppercase letter'),
        RequirementRow(fulfilled: hasLower, requirement: 'Contains a lowercase letter'),
        RequirementRow(fulfilled: hasSpecial, requirement: 'Contains a special character'),
      ],
    );
  }
}

class RequirementRow extends StatelessWidget {
  final bool fulfilled;
  final String requirement;
  const RequirementRow({required this.fulfilled, required this.requirement, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          fulfilled ? Icons.check_circle : Icons.info,
          color: fulfilled ? Colors.green : Colors.grey,
          size: 18,
        ),
        const SizedBox(width: 8),
        Text(
          requirement,
          style: TextStyle(
            color: fulfilled ? Colors.black : Colors.grey,
          ),
        ),
      ],
    );
  }
}