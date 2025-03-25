import '../Calendario/widgets/calendar_widget.dart';
import 'package:flutter/material.dart';
import '../Calendario/page/event_edit_page.dart';

class CalendaryState extends StatelessWidget {
  const CalendaryState({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Calendario'), // Asegúrate de que MyApp.title existe
          centerTitle: true,
        ),
        body: CalendarWidget(),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add, color:Colors.white),
          backgroundColor: const Color.fromARGB(255, 86, 106, 205),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => EventEditingpage()),
          ),
        ),
      );
}
