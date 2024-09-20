// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateNoteScreen extends StatefulWidget {
  const CreateNoteScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CreateNoteScreenState createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();
  String _selectedCategory = 'Vingança';

  Future<void> _saveNote() async {
    final prefs = await SharedPreferences.getInstance();
    final notes = prefs.getStringList('notes') ?? [];
    // ignore: unnecessary_brace_in_string_interps
    final note = '${_selectedCategory}|${_titleController.text}|${_messageController.text}';
    notes.add(note);
    await prefs.setStringList('notes', notes);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 68, 50, 115),
        title: const Text(
          'Criar Nota',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF701ebd),
                  Color(0xFF873bcc),
                  Color(0xFFfe4a97),
                  Color(0xFFe17763),
                  Color(0xFF68998c),
                ],
                stops: [0.1, 0.4, 0.6, 0.8, 1],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
          ),
          Positioned.fill(
            child: Opacity(
              opacity: 0.6,
              child: Image.asset(
                'images/stars.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.symmetric(horizontal: 24.0),
              decoration: BoxDecoration(
                color: Colors.pink.withOpacity(0.8),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Título',
                      filled: true,
                      fillColor: const Color(0xFF6e51bc),
                      labelStyle: const TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF6e51bc),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      controller: _messageController,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Digite sua mensagem...',
                        hintStyle: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                      ),
                      style: const TextStyle(color: Color.fromARGB(221, 255, 255, 255)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButton<String>(
                    value: _selectedCategory,
                    items: ['Vingança', 'Pessoas que gosto', 'Pessoas que não gosto']
                        .map((category) => DropdownMenuItem<String>(
                              value: category,
                              child: Text(category, style: const TextStyle(color: Colors.white)),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value!;
                      });
                    },
                    dropdownColor: const Color.fromARGB(255, 68, 50, 115),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _saveNote,
                    // ignore: sort_child_properties_last
                    child: const Text('Salvar Nota', style: TextStyle(color: Colors.white)),
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(const Color(0xFF6e51bc)),
                      padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 16, horizontal: 32)),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
