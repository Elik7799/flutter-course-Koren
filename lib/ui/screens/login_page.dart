import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String? _errorMessage;

  String _getErrorMessage(String code) {
    switch (code) {
      case 'invalid-email':
        return 'Некорректный формат email.';
      case 'user-disabled':
        return 'Этот аккаунт был отключен.';
      case 'user-not-found':
        return 'Пользователь с таким email не найден.';
      case 'wrong-password':
        return 'Неверный пароль.';
      case 'email-already-in-use':
        return 'Этот email уже занят другим аккаунтом.';
      case 'weak-password':
        return 'Слишком короткий пароль (минимум 6 символов).';
      case 'invalid-credential':
        return 'Неверный email или пароль.';
      case 'missing-password':
        return 'Некорректный пароль.';
      default:
        return 'Произошла ошибка: $code';
    }
  }

  Future<void> _signIn() async {
    try {
      setState(() => _errorMessage = null);
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      setState(() => _errorMessage = _getErrorMessage(e.code)); 
    }
  }

  Future<void> _register() async {
    try {
      setState(() => _errorMessage = null);
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      setState(() => _errorMessage = _getErrorMessage(e.code));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Вход в приложение')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Пароль', border: OutlineInputBorder()),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            if (_errorMessage != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  border: Border.all(color: Colors.red.shade200),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red.shade900, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: _signIn, child: const Text('Войти')),
            ),
            TextButton(onPressed: _register, child: const Text('Зарегистрироваться')),
          ],
        ),
      ),
    );
  }
}