import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'inicio.dart';
import 'perfil.dart';
import 'novedades.dart';
import '../page/games/games.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  String userName = '';
  int _daysConnected = 0;
  int _selectedIndex = 0;

  // Lista de pantallas para cada sección del menú
  final List<Widget> _pages = [
    const Inicio(),    // Pantalla principal
    const GameScreen(),
     NovedadesScreen(),      // Pantalla de Novedades
    const PerfilScreen(),       // Pantalla "Yo"
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    _user = _auth.currentUser;

    if (_user != null) {
      final userDoc = FirebaseFirestore.instance.collection('users').doc(_user!.uid);
      final docSnapshot = await userDoc.get();

      if (docSnapshot.exists) {
        setState(() {
          final data = docSnapshot.data();
           userName = data?['name'] ?? 'Usuario';
          _daysConnected = data?['daysConnected'] ?? 0;
        });
      }
    }
  }

  final List<IconData> _icons = [
    Icons.home,
    Icons.gamepad,
    Icons.new_releases,
    Icons.person,
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(130.0),
        child: Container(
          margin: const EdgeInsets.only(top: 25),
          child: AppBar(
            title: Row(
              children: [
                Image.asset('assets/imagenes/icono-app.png', width: 100, height: 100),
                const Spacer(),
                Row(
                  children: [
                    Image.asset('assets/imagenes/fuego.png', width: 50, height: 50),
                    const SizedBox(width: 4),
                    Text('$_daysConnected', style: const TextStyle(color: Colors.black)),
                  ],
                ),
              ],
            ),
            centerTitle: true,
            toolbarHeight: 80,
            automaticallyImplyLeading: false,
            backgroundColor: const Color.fromARGB(255, 114, 181, 245),
          ),
        ),
      ),
      body: _pages[_selectedIndex],  // Aquí se muestra la pantalla según el índice seleccionado
      bottomNavigationBar: Container(
        color: const Color.fromARGB(255, 67, 206, 230),
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(4, (index) {
            bool isSelected = index == _selectedIndex;
            return GestureDetector(
              onTap: () => _onItemTapped(index),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                  _icons[index],
                  size: isSelected ? 40 : 25, // Aumenta el tamaño si está seleccionado
                  color: isSelected ? Colors.white : Colors.black54, // Color blanco si está seleccionado
                  ),
                  
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
