import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:myapp/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'note_actions.dart'; // Certifique-se de que este é o caminho correto para o arquivo note_actions.dart

class ViewNotesScreen extends StatefulWidget {
  const ViewNotesScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ViewNotesScreenState createState() => _ViewNotesScreenState();
}

class _ViewNotesScreenState extends State<ViewNotesScreen> with WidgetsBindingObserver {
  String _selectedCategory = 'Todas';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      _logout();
    }
  }

  Future<void> _logout() async {
    // ignore: unused_local_variable
    final prefs = await SharedPreferences.getInstance();
    Navigator.pushReplacement(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  Future<List<Map<String, String>>> _getNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notes = prefs.getStringList('notes') ?? [];
    return notes.map((note) {
      final parts = note.split('|');
      return {
        'category': parts[0],
        'title': parts[1],
        'message': parts[2],
      };
    }).toList();
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Vingança':
        return Colors.red.shade900;
      case 'Pessoas que gosto':
        return Colors.blue;
      case 'Pessoas que não gosto':
        return Colors.pink.shade900;
      default:
        return Colors.black;
    }
  }

  void _showEditDialog(
      BuildContext context, String oldTitle, List<Map<String, String>> notes) {
    final titleController = TextEditingController();
    final messageController = TextEditingController();

    final currentNote = notes.firstWhere((note) => note['title'] == oldTitle);
    titleController.text = currentNote['title']!;
    messageController.text = currentNote['message']!;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 173, 66, 102),
          title: const Text(
            'Editar Nota',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                style: const TextStyle(color: Colors.white),
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              TextField(
                style: const TextStyle(color: Colors.white),
                controller: messageController,
                decoration: const InputDecoration(
                  labelText: 'Mensagem',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                final newTitle = titleController.text;
                final newMessage = messageController.text;

                editNote(
                  context,
                  oldTitle,
                  notes,
                  newTitle,
                  newMessage,
                ).then((_) {
                  setState(() {});
                  Navigator.pop(context);
                });
              },
              child: const Text('Confirmar', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // ignore: unused_element
  void _showOptions(
      BuildContext context, String noteTitle, List<Map<String, String>> notes) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 68, 50, 115), // Cor roxa para o fundo do menu
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.white),
                title: const Text('Editar', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _showEditDialog(context, noteTitle, notes);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.white),
                title: const Text('Excluir', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  deleteNote(
                    context,
                    noteTitle,
                    notes,
                  ).then((_) {
                    setState(() {});
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 68, 50, 115),
        title: Text(
          _selectedCategory == 'Todas' ? 'Notas' : _selectedCategory,
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          DropdownButton<String>(
            dropdownColor: const Color.fromARGB(255, 173, 66, 102),
            value: _selectedCategory,
            items: <String>['Todas', 'Vingança', 'Pessoas que gosto', 'Pessoas que não gosto']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: const TextStyle(color: Colors.white)),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedCategory = newValue!;
              });
            },
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
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
          FutureBuilder<List<Map<String, String>>>(
            future: _getNotes(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                    'Nenhuma nota encontrada.',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              } else {
                final filteredNotes = _selectedCategory == 'Todas'
                    ? snapshot.data!
                    : snapshot.data!.where((note) => note['category'] == _selectedCategory).toList();

                return ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: filteredNotes.map((note) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: _getCategoryColor(note['category']!).withOpacity(0.5),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            padding: const EdgeInsets.all(16.0),
                            child: ListTile(
                              title: Text(note['title']!, style: const TextStyle(color: Colors.white)),
                              subtitle: Text(note['message']!, style: const TextStyle(color: Colors.white)),
                              trailing: PopupMenuButton<String>(
                                color: const Color.fromARGB(255, 68, 50, 115), // Cor roxa para o fundo do menu
                                icon: const Icon(Icons.more_vert, color: Colors.white),
                                onSelected: (String value) {
                                  if (value == 'edit') {
                                    _showEditDialog(context, note['title']!, filteredNotes);
                                  } else if (value == 'delete') {
                                    deleteNote(
                                      context,
                                      note['title']!,
                                      filteredNotes,
                                    ).then((_) {
                                      setState(() {});
                                    });
                                  }
                                },
                                itemBuilder: (BuildContext context) {
                                  return [
                                    const PopupMenuItem<String>(
                                      value: 'edit',
                                      child: Text('Editar', style: TextStyle(color: Colors.white)),
                                    ),
                                    const PopupMenuItem<String>(
                                      value: 'delete',
                                      child: Text('Excluir', style: TextStyle(color: Colors.white)),
                                    ),
                                  ];
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
