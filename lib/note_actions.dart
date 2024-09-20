import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Função para apagar uma nota
Future<void> deleteNote(
    BuildContext context, String noteTitle, List<Map<String, String>> notes) async {
  final prefs = await SharedPreferences.getInstance();
  notes.removeWhere((note) => note['title'] == noteTitle);
  List<String> updatedNotes = notes
      .map((note) => "${note['category']}|${note['title']}|${note['message']}")
      .toList();
  await prefs.setStringList('notes', updatedNotes);

  // Feedback visual
  // ignore: use_build_context_synchronously
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Nota "$noteTitle" apagada com sucesso.'),
      backgroundColor: const Color.fromARGB(255, 156, 54, 47),
    ),
  );
}

// Função para editar uma nota
Future<void> editNote(BuildContext context, String noteTitle,
    List<Map<String, String>> notes, String newTitle, String newMessage) async {
  final prefs = await SharedPreferences.getInstance();
  
  // Encontra e edita a nota
  for (var note in notes) {
    if (note['title'] == noteTitle) {
      note['title'] = newTitle;
      note['message'] = newMessage;
    }
  }
  
  List<String> updatedNotes = notes
      .map((note) => "${note['category']}|${note['title']}|${note['message']}")
      .toList();
  await prefs.setStringList('notes', updatedNotes);

  // Feedback visual
  // ignore: use_build_context_synchronously
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Nota "$noteTitle" editada com sucesso.'),
      backgroundColor: const Color.fromARGB(255, 139, 76, 175),
    ),
  );
}
