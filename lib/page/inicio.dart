import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

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
  List articles = [];
  bool isLoading = true;
  Timer? _timer; // Para ejecutar la API cada 30 minutos

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadNews();

    // Configurar un temporizador para llamar a la API cada 30 minutos
    _timer = Timer.periodic(const Duration(minutes: 30), (timer) {
      fetchNews();
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancelar el temporizador al salir de la pantalla
    super.dispose();
  }

  /// Cargar noticias desde SharedPreferences o la API si han pasado más de 30 minutos.
  Future<void> _loadNews() async {
    setState(() => isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    final String? savedData = prefs.getString('newsData');
    final int? lastFetchTime = prefs.getInt('lastFetchTime');
    final int currentTime = DateTime.now().millisecondsSinceEpoch;

    if (savedData != null && lastFetchTime != null && (currentTime - lastFetchTime) < (30 * 60 * 1000)) {
      // Cargar datos desde SharedPreferences
      setState(() {
        articles = json.decode(savedData);
        isLoading = false;
      });
    } else {
      // Obtener nuevos datos de la API
      await fetchNews();
    }
  }

  /// Obtener noticias desde la API y guardarlas en SharedPreferences.
  Future<void> fetchNews() async {
    try {
      print("🔄 Llamando a la API para obtener noticias...");
      const String apiKey = 'pub_72267535ae0cff301e7db337e6a99c7511707';
      const String apiUrl = 'https://newsdata.io/api/1/news?country=mx&category=health&apikey=';
      final response = await http.get(Uri.parse(apiUrl + apiKey));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data.containsKey('results')) {
          setState(() {
            articles = data['results'];
            isLoading = false;
          });

          // Guardar en SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('newsData', json.encode(articles));
          await prefs.setInt('lastFetchTime', DateTime.now().millisecondsSinceEpoch);
          print("✅ Noticias guardadas en SharedPreferences");
        }
      } else {
        throw Exception('Error en la respuesta de la API');
      }
    } catch (e) {
      print('❌ Error al obtener noticias: $e');
      setState(() => isLoading = false);
    }
  }

  /// Cargar datos del usuario desde Firebase Firestore
  Future<void> _loadUserData() async {
    try {
      _user = _auth.currentUser;
      if (_user != null) {
        final userDoc = FirebaseFirestore.instance.collection('users').doc(_user!.uid);
        final docSnapshot = await userDoc.get();
        if (docSnapshot.exists) {
          final data = docSnapshot.data();
          setState(() {
            _userName = data?['name'] ?? 'Usuario';
            _daysConnected = data?['daysConnected'] ?? 0;
          });
        }
      }
    } catch (e) {
      print('Error al cargar los datos del usuario: $e');
    }
  }

  /// Función para abrir enlaces externos
  void _openUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se pudo abrir el enlace: $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Noticias de Salud en México')),
      body: RefreshIndicator(
        onRefresh: fetchNews, // Permite al usuario recargar noticias manualmente
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(), // Permite el gesto de recarga
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isLoading
                    ? const Center(child: CircularProgressIndicator()) // Indicador de carga mientras se obtienen datos
                    : articles.isEmpty
                        ? const Center(child: Text('No hay noticias disponibles.'))
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: articles.length,
                            itemBuilder: (context, index) {
                              var article = articles[index];
                              return Card(
                                margin: const EdgeInsets.all(10),
                                child: ListTile(
                                  leading: (article['image_url'] != null && Uri.parse(article['image_url']).isAbsolute)
                                      ? Image.network(
                                          article['image_url'],
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return const Icon(Icons.broken_image, size: 50);
                                          },
                                        )
                                      : const Icon(Icons.image, size: 50),
                                  title: Text(article['title'] ?? 'Sin título', maxLines: 2, overflow: TextOverflow.ellipsis),
                                  subtitle: Text(article['source_name'] ?? 'Fuente desconocida'),
                                  onTap: () => _openUrl(article['link']),
                                ),
                              );
                            },
                          ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
