import 'package:flutter/material.dart';
import '../constantes/constants.dart';
import '../Controladores/game_button.dart';
import '../pages/memory_match_page.dart';

class VistaCartas extends StatefulWidget {
  const VistaCartas({super.key});

  @override
  _VistaCartasState createState() => _VistaCartasState();
}

class _VistaCartasState extends State<VistaCartas> {
  static Route<dynamic> _routeBuilder(BuildContext context, int gameLevel) {
    return MaterialPageRoute(
      builder: (_) => MemoryMatchPage(gameLevel: gameLevel),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memory Match'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Instrucciones:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Selecciona un nivel para iniciar el juego. Encuentra las parejas de cartas idénticas lo más rápido posible.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Column(
              children: gameLevels.map((level) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GameButton(
                    onPressed: () => Navigator.of(context).push(
                      _routeBuilder(context, level['level']),
                    ),
                    title: level['title'],
                    color: level['color']!,
                    width: 250,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
