import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/event.dart';
import '../utils.dart';
import '../provider/event_provider.dart';

class EventEditingpage extends StatefulWidget {
  final Event? event;

  const EventEditingpage({
    Key? key,
    this.event,
  }) : super(key: key);

  @override
  EventEditingpageState createState() => EventEditingpageState();
}

class EventEditingpageState extends State<EventEditingpage> {
  final _formkey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  late DateTime fromDate;
  late DateTime toDate;

  @override
  void initState() {
    super.initState();

    if (widget.event == null) {
      fromDate = DateTime.now();
      toDate = DateTime.now().add(const Duration(days: 2));
    } else {
      final event = widget.event!;
      titleController.text = event.title;
      fromDate = event.from;
      toDate = event.to;
      descriptionController.text = event.description;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: const CloseButton(),
      actions: buildEditingAction(),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Form(
        key: _formkey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            buildTitle(),
            const SizedBox(height: 12),
            buildDateTimePicker(),
            const SizedBox(height: 50),
            buildDescription(),
          ],
        ),
      ),
    ),
  );

List<Widget> buildEditingAction() => [
  ElevatedButton.icon(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.transparent, // 🔹 Fondo transparente
      shadowColor: Colors.transparent, // 🔹 Elimina sombra
      foregroundColor: Colors.black, // 🔥 Texto e icono en negro
    ),
    onPressed: saveFrom,
    icon: const Icon(Icons.done, color: Colors.black), // 🔥 Icono en negro
    label: const Text(
      'Guardar',
      style: TextStyle(color: Colors.black), // 🔥 Texto en negro
    ),
  ),
];

  Widget buildTitle() => TextFormField(
    style: const TextStyle(fontSize: 24),
    decoration: const InputDecoration(
    enabledBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0), width: 2), //Color de la línea cuando NO está seleccionado
    ),
    focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Color.fromARGB(255, 68, 139, 246), width: 3), // Color de la línea cuando está seleccionado
    ),
      hintText: 'Nuevo Título',
      hintStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)), // 🎨 Color del hint text
    ),
    onFieldSubmitted: (_) => saveFrom(),
    validator: (title) => title != null && title.isEmpty
        ? 'El titulo no puede estar vacio'
        : null,
    controller: titleController,
  );

Widget buildDescription() => TextFormField(
  style: const TextStyle(fontSize: 18),
  decoration: InputDecoration(
    border: OutlineInputBorder( // Borde en todas las líneas (por defecto)
      borderRadius: BorderRadius.circular(10), // Bordes redondeados
      borderSide: const BorderSide(color: Colors.black, width: 2), // Borde negro
    ),
    enabledBorder: OutlineInputBorder( // Borde cuando NO está seleccionado
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color.fromARGB(255, 0, 0, 0), width: 2), // Borde negro cuando inactivo
    ),
    focusedBorder: OutlineInputBorder( // 🔲 Borde cuando está seleccionado
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color.fromARGB(255, 68, 139, 246), width: 3), // Borde azul cuando activo
    ),
    hintText: 'Agregar descripción',
    contentPadding: const EdgeInsets.all(12), // Espacio interno para mejorar apariencia
  ),
  maxLines: null, // Permite que el campo crezca según el texto ingresado
  minLines: 5, // Mínimo de líneas visibles
  onFieldSubmitted: (_) => saveFrom(),
  validator: (description) => description != null && description.isEmpty
      ? 'La descripción no puede estar vacía'
      : null,
  controller: descriptionController,
);


  Widget buildDateTimePicker() => Column(
    children: [
      buildFrom(),
      buildTo(),
    ],
  );

  Widget buildFrom() => buildHeader(
    header: 'DE',
    child: Row(
      children: [
        Expanded(
          flex: 1,
          child: buildDropdownField(
            text: Utils.toDate(fromDate),
            onClicked: () => pickFromDateTime(pickDate: true),
          ),
        ),
        Expanded(
          child: buildDropdownField(
            text: Utils.toTime(fromDate),
            onClicked: () => pickFromDateTime(pickDate: false),
          ),
        ),
      ],
    ),
  );

  Widget buildTo() => buildHeader(
    header: 'ASTA',
    child: Row(
      children: [
        Expanded(
          flex: 1,
          child: buildDropdownField(
            text: Utils.toDate(toDate),
            onClicked: () => pickToDateTime(pickDate: true),
          ),
        ),
        Expanded(
          child: buildDropdownField(
            text: Utils.toTime(toDate),
            onClicked: () => pickToDateTime(pickDate: false),
          ),
        ),
      ],
    ),
  );

  Future pickFromDateTime({required bool pickDate}) async {
    final date = await pickDateTime(fromDate, pickDate: pickDate);
    if (date == null) return;

    if (date.isAfter(toDate)) {
      toDate = DateTime(date.year, date.month, date.day, toDate.hour, toDate.minute);
    }
    setState(() => fromDate = date);
  }

  Future pickToDateTime({required bool pickDate}) async {
    final date = await pickDateTime(toDate, pickDate: pickDate, firstDate: pickDate ? fromDate : null);
    if (date == null) return;

    setState(() => toDate = date);
  }

  Future<DateTime?> pickDateTime(DateTime initialDate, {required bool pickDate, DateTime? firstDate}) async {
    if (pickDate) {
      final date = await showDatePicker(
        context: context,
        firstDate: firstDate ?? DateTime(2024, 8),
        lastDate: DateTime(2101),
      );
      if (date == null) return null;

      final time = Duration(hours: initialDate.hour, minutes: initialDate.minute);
      return date.add(time);
    } else {
      final timeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );
      if (timeOfDay == null) return null;

      final date = DateTime(initialDate.year, initialDate.month, initialDate.day);
      final time = Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);
      return date.add(time);
    }
  }

  Widget buildDropdownField({required String text, required VoidCallback onClicked}) => ListTile(
    title: Text(text),
    trailing: const Icon(Icons.arrow_drop_down),
    onTap: onClicked,
  );

  Widget buildHeader({required String header, required Widget child}) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(header, style: const TextStyle(fontWeight: FontWeight.bold)),
      const SizedBox(height: 15),
      child,
    ],
  );

  Future saveFrom() async {
    final isValid = _formkey.currentState!.validate();
    if (isValid) {
      final event = Event(
        id: widget.event?.id ?? generateUniqueId(), // Si es edición, usa el id existente, si no, genera uno nuevo
        title: titleController.text,
        description: descriptionController.text,
        from: fromDate,
        to: toDate,
        isAllDay: false,
      );

      final isEditing = widget.event != null;
      final provider = Provider.of<EventProvider>(context, listen: false);

      if (isEditing) {
        final index = provider.events.indexWhere((e) => e.id == widget.event!.id);
        if (index != -1) {
          provider.editEvent(event, widget.event!); // Aquí se editan los eventos
        } else {
          print("El evento no se encuentra en la lista.");
        }
      } else {
        provider.addEvent(event); // Si es un evento nuevo, se agrega
      }

      Navigator.pop(context);
    }
  }

  int generateUniqueId() {
    return DateTime.now().millisecondsSinceEpoch; // ID único basado en el tiempo
  }
}
