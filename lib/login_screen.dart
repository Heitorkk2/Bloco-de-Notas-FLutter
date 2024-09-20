// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main_screen.dart';
import 'forgot_password_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscured = true;
  bool _isFirstVisit = true;
  String _savedPassword = '';
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkFirstVisit();
  }

  Future<void> _checkFirstVisit() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? savedPassword = prefs.getString('password');
    if (savedPassword != null) {
      setState(() {
        _isFirstVisit = false;
        _savedPassword = savedPassword;
      });
    }
  }

  Future<void> _handleLogin() async {
    final String enteredPassword = _passwordController.text;
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (_isFirstVisit) {
      await prefs.setString('password', enteredPassword);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } else if (enteredPassword == _savedPassword) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Senha incorreta')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF6e51bc),
        title: const Text(
          "MyList~",
          style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic),
        ),
        centerTitle: true,
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
                'images/stars.png', // Certifique-se de que o caminho da imagem está correto
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
                  Text(
                    _isFirstVisit ? 'Crie uma Senha' : 'Digite a Senha',
                    style: const TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    obscureText: _isObscured,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.3),
                      hintText: 'Senha',
                      hintStyle: const TextStyle(color: Colors.white70),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscured ? Icons.visibility : Icons.visibility_off,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscured = !_isObscured;
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
                    onPressed: _handleLogin,
                    // ignore: sort_child_properties_last
                    child: const Text('Entrar', style: TextStyle(color: Colors.white)),
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
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
                      );
                    },
                    child: const Text(
                      'Esqueci minha senha',
                      style: TextStyle(color: Colors.white70, decoration: TextDecoration.underline),
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
