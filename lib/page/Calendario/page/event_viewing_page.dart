import 'package:buenos_habitos/page/Calendario/model/event.dart';
import 'package:buenos_habitos/page/Calendario/page/event_edit_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../provider/event_provider.dart';

class EventViewingPage extends StatelessWidget {
  final Event event;

  const EventViewingPage({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: CloseButton(),
          actions: buildViewingAction(context, event),
        ),
        body: ListView(
          padding: const EdgeInsets.all(32),
          children: <Widget>[
            buildDateTime(event),
            const SizedBox(height: 32),
            const Text('Titulo de la Actividad'),
            const SizedBox(height: 12),
            Container(
            padding: const EdgeInsets.only(bottom: 4), // Espaciado interno solo abajo
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey, width: 2), // Línea debajo del texto
              ),
            ),
            child: Text(
              event.title,
              style: const TextStyle(fontSize: 24),
            ),
          ),
            const SizedBox(height: 34),
            const Text('Descrpción de la Actividad'),
            const SizedBox(height: 12),
            Container(
            padding: const EdgeInsets.all(12), // Espaciado interno
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey), // Borde del cuadro
              borderRadius: BorderRadius.circular(8), // Bordes redondeados
            ),
            child: Text(
              event.description,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          ],
        ),
      );

  Widget buildDateTime(Event event) {
    return Column(
      children: [
        buildDate(event.isAllDay ? 'Todo el día' : 'Desde', event.from),
        if (!event.isAllDay) buildDate('Hasta', event.to),
      ],
    );
  }

Widget buildDate(String title, DateTime date) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribuye los elementos
    children: [
      Expanded(
        flex: 1,
        child: Text(
          title,
          style: TextStyle(fontSize: 18),
        ),
      ),
      const SizedBox(height: 50),
      Expanded(
        flex: 2, // Puedes ajustar el tamaño según lo que necesites
        child: Text(
          '${date.toLocal()}'.split(' ')[0], // Formatea la fecha a solo día
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.right, // Alinea el texto a la derecha
        ),
      ),
    ],
  );
}


  List<Widget> buildViewingAction(BuildContext context, Event event) {
    return [
      IconButton(
        icon: Icon(Icons.edit),
        onPressed: () => Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => EventEditingpage(event: event),
          ),
        ),
      ),
      IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {
          final provider = Provider.of<EventProvider>(context, listen: false);
          provider.deleteEvent(event);
          Navigator.pop(context);
        },
      ),
    ];
  }
}
