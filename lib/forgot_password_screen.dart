// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart'; // Importe sua tela de login

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Autenticando';
      });
      authenticated = await auth.authenticate(
        localizedReason: 'Use sua digital (ou face) para logar no aplicativo',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      setState(() {
        _isAuthenticating = false;
      });
    } on PlatformException catch (e) {
      // ignore: avoid_print
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - ${e.message}';
      });
      return;
    }
    if (!mounted) {
      return;
    }

    if (authenticated) {
      await _resetPassword();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } else {
      setState(() {
        _authorized = 'Não Autorizado';
      });
    }
  }

  Future<void> _resetPassword() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('password'); // Remove a senha
    setState(() {
// Suggested code may be subject to a license. Learn more: ~LicenseLog:603396126.
      _authorized = 'Senha redefinida com sucesso';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF6e51bc),
        title: const Text(
          "Resetar Senha",
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  _authorized,
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                ),
                const SizedBox(height: 20),
                if (_isAuthenticating)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: _authenticate,
                    // ignore: sort_child_properties_last
                    child: const Text('Autenticar com Biometria', style: TextStyle(color: Colors.white),),
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
        ],
      ),
    );
  }
}
