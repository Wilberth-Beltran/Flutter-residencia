import 'package:buenos_habitos/page/principal-admin.dart';
import 'package:flutter/material.dart';

class ConfirmationAdminScreen extends StatelessWidget {
  const ConfirmationAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Inicia el temporizador para redirigir después de unos segundos
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AdminHomePage()), // Cambia por la página de destino
      );
    });

    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 100,
            ),
            SizedBox(height: 20),
            Text(
              '¡Sesión exitosa!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
