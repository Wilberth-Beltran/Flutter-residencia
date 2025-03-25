import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'perfil.dart';
import 'novedades.dart';
import '../page/games/games.dart';
import 'Calendario/Vista_principal.dart';
import 'page1_icons/home_page.dart';

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
    const Home_Page(),   // Pantalla principal
    const GameScreen(),
    NovedadesScreen(),      // Pantalla de Novedades
    const CalendaryState(),    // Pantalla de perfil
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
    Icons.calendar_today,
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
      body: _pages[_selectedIndex],  // Aquí se muestra la pantalla según el índice seleccionado
      bottomNavigationBar: Container(
      color: Theme.of(context).bottomNavigationBarTheme.backgroundColor, // ✅ Se adapta al tema  
      padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(5, (index) {
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
