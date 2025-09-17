import 'package:flutter/material.dart';
import 'package:home_workout_app/services/google_signin_service.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Welcome to Home Workout",
              style: TextStyle(
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                minimumSize: const Size(220, 50),
              ),
              icon: Image.asset(
                'assets/icons/google.png', // add a google.png under assets/icons/
                height: 24,
              ),
              label: const Text("Continue with Google"),
              onPressed: () async {
                final user = await GoogleSignInService.signInWithGoogle();
                if (user != null) {
                  print("Signed in as ${user.displayName}");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
