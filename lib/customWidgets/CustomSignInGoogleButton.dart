import 'package:flutter/material.dart';

import '../services/AuthService.dart';

class CustomSignInGoogleButton extends StatelessWidget {
  CustomSignInGoogleButton({super.key});

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: MaterialButton(
        onPressed: () {
          _authService.signInWithGoogle();
        },
        shape: const StadiumBorder(),
        height: 40.0,
        color: const Color(0xFFF2F2F2),
        elevation: 0,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              image: AssetImage("assets/images/g-logo.png"),
              height: 26.0,
              width: 26.0,
            ),
            SizedBox(
              width: 10.0,
            ),
            Text(
              "Iniciar sesión con Google",
              style: TextStyle(
                fontSize: 18,
              ),
            )
          ],
        ),
      ),
    );
  }
}
