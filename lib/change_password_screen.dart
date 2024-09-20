// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  bool _isObscuredOld = true;
  bool _isObscuredNew = true;
  String _savedPassword = '';

  @override
  void initState() {
    super.initState();
    _loadSavedPassword();
  }

  Future<void> _loadSavedPassword() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? savedPassword = prefs.getString('password');
    if (savedPassword != null) {
      setState(() {
        _savedPassword = savedPassword;
      });
    }
  }

  Future<void> _handleChangePassword() async {
    final String oldPassword = _oldPasswordController.text;
    final String newPassword = _newPasswordController.text;
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (oldPassword == _savedPassword) {
      await prefs.setString('password', newPassword);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Senha alterada com sucesso')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Senha antiga incorreta')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF6e51bc),
        title: const Text(
          'Mudar Senha',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image and Gradient
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
            child: Opacity(
              opacity: 0.6,
              child: Image.asset(
                'images/stars.png', // Substitua pelo caminho da sua imagem
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
                  const Text(
                    'Mudar Senha',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _oldPasswordController,
                    obscureText: _isObscuredOld,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.3),
                      hintText: 'Senha Antiga',
                      hintStyle: const TextStyle(color: Colors.white70),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscuredOld ? Icons.visibility : Icons.visibility_off,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscuredOld = !_isObscuredOld;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _newPasswordController,
                    obscureText: _isObscuredNew,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.3),
                      hintText: 'Nova Senha',
                      hintStyle: const TextStyle(color: Colors.white70),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscuredNew ? Icons.visibility : Icons.visibility_off,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscuredNew = !_isObscuredNew;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _handleChangePassword,
                    // ignore: sort_child_properties_last
                    child: const Text('Alterar Senha', style: TextStyle(color: Colors.white)),
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
