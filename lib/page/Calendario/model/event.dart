import 'dart:ffi';

import 'package:flutter/material.dart';

class Event {
  final int id;
  final String title;
  final String description;
  final DateTime from;
  final DateTime to;
  final Color backgroundColor;
  final bool isAllDay;

  const Event({
    required this.id,
    required this.title,
    required this.description,
    required this.from,
    required this.to,
    this.backgroundColor = const Color.fromARGB(255, 255, 255, 255),
    this.isAllDay = false,
  });

  // Convertir a JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'from': from.toIso8601String(),
        'to': to.toIso8601String(),
        'backgroundColor': backgroundColor.value, // Guardamos el color como int
        'isAllDay': isAllDay,
      };

  // Crear objeto desde JSON
  factory Event.fromJson(Map<String, dynamic> json) => Event(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        from: DateTime.parse(json['from']),
        to: DateTime.parse(json['to']),
        backgroundColor: Color(json['backgroundColor']), // Convertimos int a Color
        isAllDay: json['isAllDay'],
      );
}
