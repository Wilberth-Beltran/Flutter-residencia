import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pedometer/pedometer.dart';
import '../actualizar-datos.dart';


class Home_Page extends StatefulWidget {
  const Home_Page({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Home_Page> {
  int _selectedIndex = 0;
  final ValueNotifier<int> _steps = ValueNotifier<int>(0);
  int kgperdido = 154000; //cantidad de pasos para perder un kilo
  double pasogr = 0.0066; //1 paso pierdes 0.0066 gramos de peso
  double pesoperdido = 0;


  @override
  void initState() {
    super.initState();
    _initPermissions();

  }

  Future<void> _initPermissions() async {
    var status = await Permission.activityRecognition.request();
    if (status.isGranted) {
      _startPedometer();
    } else {
      print("Permiso denegado");
    }
  }

  void _startPedometer() {
    Pedometer.stepCountStream.listen((StepCount event) {
      _steps.value = event.steps;
       pesoperdido = _steps.value * pasogr;
    }).onError((error) {
      print("Error en el podómetro: $error");
    });
  }

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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inicio"),
        centerTitle: true,
      ),
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
          final weightInitial = (userData['weightInitial'] ?? 0.0).toDouble();
          final weight = (userData['weight'] ?? 0.0).toDouble();
          final weightLost = weightInitial > 0.0 ? weightInitial - weight : 0.0;
          final glucose = (userData['glucose'] ?? 0.0).toDouble();
           

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [

                const SizedBox(height: 20),

                // Verifica si se deben mostrar los datos o el botón de "Subir Datos"
                _shouldShowUploadButton(weightInitial, weight, weightLost, glucose)
                    ? _buildUploadButton()
                    : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      
                      // Podómetro se actualiza en tiempo real
                      ValueListenableBuilder<int>(
                        valueListenable: _steps,
                        builder: (context, steps, child) {
                          return _buildPedometerCard(steps);
                        },
                      ),
                      const SizedBox(height: 20),

                      const Text(
                        "Datos del Usuario",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),

                      // Fila con dos columnas
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                _buildCombinedDataCard("Peso Ini. Kg", "$weightInitial", "Peso Perd. g", "$pesoperdido" ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                _buildCombinedDataCard("Peso Act. Kg", "$weight", "Cont Glucosa", "$glucose"),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const Text(
                        "Recomendación del dia",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),

                      Row(
                        children: [
                          const Text(
                            "Dato:", // Etiqueta fija
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(width: 10), // Espacio entre el texto y el cuadro de texto
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "Ingrese valor aquí",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              ),
                            ),
                          ),
                        ],
                      )

                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Función para verificar si se deben subir los datos
  bool _shouldShowUploadButton(double weightInitial, double weight, double weightLost, double glucose) {
    return (weightInitial == 0.0 || weightInitial == 0)  && (weight == 0.0 || weight == 0) && (weightLost == 0.0 || weightLost == 0) && (glucose == 0.0 || glucose == 0);
  }

  Widget _buildCombinedDataCard(String title1, String value1, String title2, String value2) {
  return Card(
    color: const Color.fromARGB(255, 255, 255, 126), // 🔵 Cambia el color de fondo
    margin: const EdgeInsets.symmetric(vertical: 30),
    child: Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title1, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text(value1, style: const TextStyle(fontSize: 22)),

          const SizedBox(height: 16),

          Text(title2, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text(value2, style: const TextStyle(fontSize: 22)),
        ],
      ),
    ),
  );
}


  Widget _buildPedometerCard(int steps) {
    return Card(
      color: const Color.fromARGB(255, 255, 126, 126), // 🔵 Cambia el color de fondo
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: const Icon(Icons.directions_walk, size: 40, color: Colors.blue),
        title: const Text(
          "Pasos de hoy",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "$steps pasos",
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

Widget _buildUploadButton() {
  return Card(
    elevation: 4.0,
    margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0), // Bordes redondeados
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Advertencia",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10), // Espacio entre el texto y el botón
          const Text(
            "Para poder acceder a todas características que ofrece esta aplicación por favor ingresar sus datos de salud en la siguiente página.",
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20), // Espacio antes del botón
          Center(
            child: ElevatedButton(
              onPressed: () async {
                // Navegar a la página de actualización de datos
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditPerfilScreen(),
                  ),
                );

                // Volver y actualizar el estado para obtener los datos más recientes
                setState(() {});
              },
              child: const Text(
                "Actualizar datos",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

}
