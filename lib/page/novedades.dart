import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import './page1_icons/inicio.dart';

class NovedadesScreen extends StatefulWidget {
  @override
  _NovedadesScreenState createState() => _NovedadesScreenState();
}

class _NovedadesScreenState extends State<NovedadesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sección de Novedades'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Novedades"),
            Tab(text: "Favoritos"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildNovedadesTab(),
           const Inicio()// Puedes personalizar esta pestaña
        ],
      ),
    );
  }

  Widget _buildNovedadesTab() {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('novedades').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No hay novedades disponibles."));
        }

        final novedades = snapshot.data!.docs;
        return ListView.builder(
          itemCount: novedades.length,
          itemBuilder: (context, index) {
            final novedad = novedades[index].data() as Map<String, dynamic>;
            final type = novedad['type'];
            final title = novedad['title'];
            final description = novedad['description'];
            final url = novedad['url'];

            if (type == 'video') {
              return VideoCard(url: url, title: title, description: description);
            } else if (type == 'pdf') {
              return PdfCard(url: url, title: title, description: description);
            }
            return const SizedBox.shrink();
          },
        );
      },
    );
  }
}

class VideoCard extends StatelessWidget {
  final String url;
  final String title;
  final String description;

  const VideoCard({required this.url, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    final videoId = YoutubePlayer.convertUrlToId(url);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        margin: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(description, style: const TextStyle(fontSize: 14)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: YoutubePlayer(
                controller: YoutubePlayerController(
                  initialVideoId: videoId!,
                  flags: const YoutubePlayerFlags(autoPlay: false),
                ),
                showVideoProgressIndicator: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PdfCard extends StatelessWidget {
  final String url;
  final String title;
  final String description;

  const PdfCard({required this.url, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        margin: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(description, style: const TextStyle(fontSize: 14)),
            ),
            TextButton(
              onPressed: () {
                launchURL(url);
              },
              child: const Text('Abrir el documento PDF'),
            ),
          ],
        ),
      ),
    );
  }

  void launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se puede abrir la URL $url';
    }
  }
}

