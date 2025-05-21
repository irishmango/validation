import 'package:flutter/material.dart';
import 'package:validation/confirmation_screen.dart';

class ValidationScreen extends StatefulWidget {
  const ValidationScreen({super.key});

  @override
  State<ValidationScreen> createState() => _ValidationScreenState();
}

class _ValidationScreenState extends State<ValidationScreen> {
  final _usernameController = TextEditingController();
  final _emailController  = TextEditingController();
  final _passwordController = TextEditingController();
  final _repeatPasswordController = TextEditingController();

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

    if (!RegExp(r'^[A-Za-z]').hasMatch(userInput)) {
      return "Must start with a letter";
    }

    if (RegExp(r'[äöüÄÖÜß]').hasMatch(userInput)) {
      return "Umlauts not allowed.";
    }

    if (RegExp(
      r'[\u203C-\u3299\uD83C\uD000-\uDFFF\uD83D\uD000-\uDFFF\uD83E\uD000-\uDFFF]'
    ).hasMatch(userInput)) {
      return "No emojis allowed";
    }

    return null;
  }

  String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
    return "Email is required.";
    }
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
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

  OutlineInputBorder getFocusedBorder(
    TextEditingController controller,
    String? Function(String?) validator,
  ) {
    final isValid = controller.text.isNotEmpty && validator(controller.text) == null;
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: isValid ? Colors.green : Colors.grey,
        width: 2,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(() => setState(() {}));
    _emailController.addListener(() => setState(() {}));
    _passwordController.addListener(() => setState(() {}));
    _repeatPasswordController.addListener(() => setState(() {}));
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
          spacing: 40,
          children: [
            Center(
              child: Text("Create a new account", style: TextStyle(fontSize: 36),),
            ),
            Column(
              spacing: 12,
              children: [
                TextFormField(
              controller: _usernameController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: validateUsername,
              decoration: InputDecoration(
                hintText: "Username",
                border: OutlineInputBorder(),
                focusedBorder: getFocusedBorder(_usernameController, validateUsername),
              ),
            ),
            SizedBox(height: 12),

            TextFormField(
              controller: _emailController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: validateEmail,
              decoration: InputDecoration(
                hintText: "Email",
                border: OutlineInputBorder(),
                focusedBorder: getFocusedBorder(_emailController, validateEmail),
              ),
            ),
            SizedBox(height: 12),

            TextFormField(
              controller: _passwordController,
              obscureText: true,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: validatePassword,
              decoration: InputDecoration(
                hintText: "Password",
                border: OutlineInputBorder(),
                focusedBorder: getFocusedBorder(_passwordController, validatePassword),
              ),
            ),
            SizedBox(height: 12),

            TextFormField(
              controller: _repeatPasswordController,
              obscureText: true,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: validateRepeatPassword,
              decoration: InputDecoration(
                hintText: "Repeat Password",
                border: OutlineInputBorder(),
                focusedBorder: getFocusedBorder(_repeatPasswordController, validateRepeatPassword),
              ),
            ),
              ],
            ),
            FilledButton(
              onPressed: (validateUsername(_usernameController.text) == null &&
                          validateEmail(_emailController.text) == null &&
                          validatePassword(_passwordController.text) == null &&
                          validateRepeatPassword(_repeatPasswordController.text) == null)
                  ? () {
                      Navigator.push(context, MaterialPageRoute(builder: (ctx) => ConfirmationScreen())); 
                    }
                  : null, 
              style: FilledButton.styleFrom(
                backgroundColor: (validateUsername(_usernameController.text) == null &&
                                  validateEmail(_emailController.text) == null &&
                                  validatePassword(_passwordController.text) == null &&
                                  validateRepeatPassword(_repeatPasswordController.text) == null)
                    ? const Color.fromRGBO(47, 93, 1, 1)
                    : Colors.grey,
              ),
              child: const Text("Register"),
            )
          ],
        ),
      ),
    );
  }
}