import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/event.dart';


class EventProvider extends ChangeNotifier {
  List<Event> _events = [];
  List<Event> get events => _events;

  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;

  // Constructor que carga los eventos al iniciar la aplicación
  EventProvider() {
    loadEvents(); // Cargar eventos desde SharedPreferences al iniciar
  }

  void setDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }


  // Filtrar eventos por la fecha seleccionada
// Filtrar eventos que incluyan la fecha seleccionada
List<Event> get eventOfSelectedDate => _events.where((event) =>
    event.from.isBefore(_selectedDate.add(Duration(days: 1))) &&
    event.to.isAfter(_selectedDate.subtract(Duration(days: 1)))
).toList();


  // Agregar evento y guardar en SharedPreferences
  void addEvent(Event event) {
    _events.add(event);
    saveEvents(); // Guardar eventos después de agregar uno nuevo
    notifyListeners();
  }



  // Guardar los eventos en SharedPreferences
  Future<void> saveEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> eventList =
        _events.map((event) => json.encode(event.toJson())).toList();
    await prefs.setStringList('events', eventList);
  }

  // Cargar los eventos desde SharedPreferences
  Future<void> loadEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? eventList = prefs.getStringList('events');

    if (eventList != null) {
      _events = eventList
          .map((eventString) => Event.fromJson(json.decode(eventString)))
          .toList();
      notifyListeners();
    }
  }

void editEvent(Event newEvent, Event oldEvent) {
  final index = _events.indexWhere((event) => event.id == oldEvent.id);

  // Verificar si el evento fue encontrado
  if (index != -1) {
    _events[index] = newEvent;
    notifyListeners();
  } else {
    print("El evento no fue encontrado en la lista.");
  }
}

void deleteEvent(Event event) {
    _events.removeWhere((e) => e.id == event.id);
    notifyListeners();
  }


}
