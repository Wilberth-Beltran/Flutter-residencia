import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'login/login.dart';
import 'actualizar-datos.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  // Método para obtener los datos del usuario
  Future<Map<String, dynamic>> getUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(user.uid);
      final snapshot = await userDoc.get();
      return snapshot.data() ?? {};
    }
    return {};
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final userData = snapshot.data ?? {};

          // Obtén los datos del usuario
          final nombre = userData['name'] ?? 'Usuario';
          final email = userData['email'] ?? 'No disponible';
          
          // Determina si los parámetros de salud son saludables
          //bool isHealthyWeight = weight >= 18.5 && weight <= 24.9;
          //bool isHealthyGlucose = glucose >= 70 && glucose <= 100;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Sección 1: Nombre 
                  const SizedBox(height: 80),
                  Card(
                      elevation: 5,
                      child: ListTile(
                        title: const Text(
                          "Nombre",
                          style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 0, 0)),
                        ),
                        subtitle: Text(
                          nombre,
                          style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 78, 78, 78)),
                        ),
                      ),
                    ),
                   const SizedBox(height: 15),

                    // Card para el Email
                    Card(
                      elevation: 5,
                      child: ListTile(
                        title: const Text(
                          "Correo Electrónico",
                          style:  TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 0, 0)),
                        ),
                        subtitle: Text(
                          email,
                          style: const TextStyle(fontSize: 19, color: Colors.blue),
                        ),
                      ),
                    ),
                  const SizedBox(height: 30),

                  // Botón de cerrar sesión
                  ElevatedButton(
  onPressed: () async {
    try {
      // Cerrar sesión en Firebase
      await FirebaseAuth.instance.signOut();

      // Cerrar sesión en Google si el usuario la usó
      final GoogleSignIn googleSignIn = GoogleSignIn();
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }

      // Borrar datos de sesión en SharedPreferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('isLoggedIn');
      await prefs.remove('userId');
      await prefs.remove('userRole');

      // Navegar a la pantalla de login y eliminar historial
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (Route<dynamic> route) => false,
      );

      // Mostrar mensaje de confirmación
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cerraste sesión correctamente')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cerrar sesión: $e')),
      );
    }
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.red,
    foregroundColor: Colors.white,
    textStyle: const TextStyle(fontSize: 16),
    minimumSize: const Size(double.infinity, 50),
  ),
  child: const Text('Cerrar sesión'),
),

                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
