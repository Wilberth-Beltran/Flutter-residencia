import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../platoBuenComer.dart';
import '../introduccion-biencomer.dart';
import 'Cards/vista/Vista_cartas.dart';
import 'Quizz/screen/main_menu.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

void _navigateToPlatoDelBuenComer(BuildContext context) async {
  final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
  final userDoc = FirebaseFirestore.instance.collection('users').doc(uid);
  final docSnapshot = await userDoc.get();

  final hasSeenIntro = docSnapshot.exists && docSnapshot.data()?['hasSeenIntro'] == true;

  if (hasSeenIntro) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PlatoDelBuenComerApp(),
      ),
    );
  } else {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IntroductionScreen(uid: uid),
      ),
    );
  }
}

  void _navigateToVistaCartas(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const VistaCartas(),
      ),
    );
  }

  void _navigateToCustionario(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MainMenu(),
      ),
    );
  }



   @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        title: const Text('Aprende Jugando'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 2),

              /// **Fila 1 - Plato del buen comer**
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildGameButton(
                    context,
                    'assets/imagenes/platocm.png',
                    'Plato del buen comer',
                    _navigateToPlatoDelBuenComer,
                  ),
                  _buildGameButton(
                    context,
                    'assets/imagenes/plato_buen_comer.png',
                    'Plato del bien comer Yucatán',
                    _navigateToPlatoDelBuenComer,
                  ),
                ],
              ),

              const SizedBox(height: 30),

              /// **Fila 2 - Juegos**
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildGameButton(
                    context,
                    'assets/imagenes/plato_buen_comer.png',
                    'Memoria de cartas',
                    _navigateToVistaCartas,
                  ),
                  _buildGameButton(
                    context,
                    'assets/imagenes/plato_buen_comer.png',
                    'Adivina la palabra',
                    _navigateToPlatoDelBuenComer,
                  ),
                ],
              ),

              const SizedBox(height: 30),

              /// **Fila 3 - Cuestionarios**
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildGameButton(
                    context,
                    'assets/imagenes/plato_buen_comer.png',
                    'Cuestionarios',
                    _navigateToCustionario,
                  ),
                  _buildGameButton(
                    context,
                    'assets/imagenes/plato_buen_comer.png',
                    'Plato del bien comer',
                    _navigateToPlatoDelBuenComer,
                  ),
                ],
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  /// **Método para construir los botones con imágenes**
  Widget _buildGameButton(
    BuildContext context,
    String imagePath,
    String title,
    Function(BuildContext) onTap,
  ) {
return SizedBox(
  width: 130, // Ancho fijo para todos los botones
  height: 150, // Alto fijo para todos los botones
  child: OutlinedButton(
    onPressed: () => onTap(context),
    style: OutlinedButton.styleFrom(
      padding: const EdgeInsets.all(10),
      backgroundColor: const Color.fromARGB(255, 114, 181, 245),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      side: BorderSide.none,
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center, // Centrar contenido verticalmente
      children: [
        Image.asset(
          imagePath,
          width: 60,
          height: 60,
        ),
        const SizedBox(height: 5),
        Text(
          title,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
        ),
      ],
    ),
  ),
);

  }
}

