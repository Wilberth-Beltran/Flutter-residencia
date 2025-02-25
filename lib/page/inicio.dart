import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'platoBuenComer.dart';
import 'introduccion-biencomer.dart';
import 'Cards/vista/Vista_cartas.dart';
import 'Quizz/screen/main_menu.dart';

class Inicio extends StatefulWidget {
  const Inicio({Key? key}) : super(key: key);

  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  String _userName = '';
  int _daysConnected = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      _user = _auth.currentUser;

      if (_user != null) {
        final userDoc = FirebaseFirestore.instance.collection('users').doc(_user!.uid);
        final docSnapshot = await userDoc.get();

        if (docSnapshot.exists) {
          setState(() {
            final data = docSnapshot.data();
            _userName = data?['name'] ?? 'Usuario';
            _daysConnected = data?['daysConnected'] ?? 0;
          });
        }
      }
    } catch (e) {
      print('Error al cargar los datos del usuario: $e');
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black),
                children: [
                  const TextSpan(
                    text: 'Bienvenido\n',
                    style: TextStyle(fontSize: 20),
                  ),
                  TextSpan(
                    text: _userName,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Primer botón con imagen
                OutlinedButton(
                  onPressed: () {
                    _navigateToPlatoDelBuenComer(context);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(10),
                    minimumSize: const Size(100, 130),
                    backgroundColor: Color.fromARGB(255, 114, 181, 245), // Color de fondo
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    side: BorderSide.none
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 110, // Limita el tamaño máximo
                      maxHeight: 110, // Limita el tamaño máximo
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/imagenes/platocm.png',
                          width: 65,
                          height: 65,
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'Plato del bien comer',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))
                        ),
                      ],
                    ),
                  ),
                ),


                // Segundo botón con imagen
                OutlinedButton(
                  onPressed: () {
                    _navigateToPlatoDelBuenComer(context);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(10),
                    backgroundColor: const Color.fromARGB(255, 114, 181, 245),
                    minimumSize: const Size(100, 130),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    side: BorderSide.none
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 110, // Limita el tamaño máximo
                      maxHeight: 110, // Limita el tamaño máximo
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/imagenes/plato_buen_comer.png',
                          width: 60,
                          height: 60,
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'Plato del bien comer yucatan',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Primer botón con imagen
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const VistaCartas()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(10),
                    backgroundColor: Color.fromARGB(255, 114, 181, 245),
                    minimumSize: const Size(100, 130),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    side: BorderSide.none
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 110, // Limita el tamaño máximo
                      maxHeight: 110, // Limita el tamaño máximo
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/imagenes/plato_buen_comer.png',
                          width: 60,
                          height: 60,
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'Memoria de cartas',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))
                        ),
                      ],
                    ),
                  ),
                ),

                // Segundo botón con imagen
                OutlinedButton(
                  onPressed: () {
                    _navigateToPlatoDelBuenComer(context);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(10),
                    backgroundColor: Color.fromARGB(255, 114, 181, 245),
                    minimumSize: const Size(100, 130),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    side: BorderSide.none
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 110, // Limita el tamaño máximo
                      maxHeight: 110, // Limita el tamaño máximo
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/imagenes/plato_buen_comer.png',
                          width: 60,
                          height: 60,
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'Adivina la palabra',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
                        Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Primer botón con imagen
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MainMenu()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(10),
                    backgroundColor: Color.fromARGB(255, 114, 181, 245),
                    minimumSize: const Size(130, 130),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    side: BorderSide.none
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 110, // Limita el tamaño máximo
                      maxHeight: 110, // Limita el tamaño máximo
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/imagenes/plato_buen_comer.png',
                          width: 60,
                          height: 60,
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'Cuestionarios',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))
                        ),
                      ],
                    ),
                  ),
                ),

                // Segundo botón con imagen
                OutlinedButton(
                  onPressed: () {
                    _navigateToPlatoDelBuenComer(context);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(10),
                    backgroundColor: Color.fromARGB(255, 114, 181, 245),
                    minimumSize: const Size(100, 130),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    side: BorderSide.none
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 110, // Limita el tamaño máximo
                      maxHeight: 110, // Limita el tamaño máximo
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/imagenes/plato_buen_comer.png',
                          width: 60,
                          height: 60,
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'Plato del bien comer',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
}

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
