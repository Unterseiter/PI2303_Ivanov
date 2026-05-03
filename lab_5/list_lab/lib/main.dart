import 'package:flutter/material.dart';
import 'dart:math';  // для возведения в степень

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Списки',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MainMenuScreen(),
    );
  }
}

// --- Главный экран с тремя кнопками для выбора ---
class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Лабораторная работа №5'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SimpleListScreen()),
                );
              },
              child: const Text('1. Простой список (3 элемента)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const InfinityListScreen()),
                );
              },
              child: const Text('2. Бесконечный список (номера строк)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const InfinityMathListScreen()),
                );
              },
              child: const Text('3. Бесконечный список (степени числа 2)'),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// 1. ПРОСТОЙ СПИСОК (3 строки с фиксированными данными)
// ============================================================
class SimpleListScreen extends StatelessWidget {
  const SimpleListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Простой список'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.one_k),
            title: Text('Первый элемент'),
            subtitle: Text('Это пример простого списка'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.two_k),
            title: Text('Второй элемент'),
            subtitle: Text('Здесь можно добавить любые данные'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.three_k),
            title: Text('Третий элемент'),
            subtitle: Text('Список конечен, дальше прокрутки нет'),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// 2. БЕСКОНЕЧНЫЙ СПИСОК (отображает номер строки)
// Используем ListView.builder для динамической подгрузки
// ============================================================
class InfinityListScreen extends StatelessWidget {
  const InfinityListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Бесконечный список'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          // index начинается с 0, но мы покажем строку 1,2,3...
          return ListTile(
            leading: Icon(Icons.numbers),
            title: Text('Строка номер ${index + 1}'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          );
        },
      ),
    );
  }
}

// ============================================================
// 3. БЕСКОНЕЧНЫЙ СПИСОК СО СТЕПЕНЯМИ ЧИСЛА 2
// Используем библиотеку dart:math для pow()
// Формула: 2^index
// ============================================================
class InfinityMathListScreen extends StatelessWidget {
  const InfinityMathListScreen({super.key});

  // Функция для вычисления 2 в степени n (возвращает строку с результатом)
  String _calculatePower(int n) {
    // math.pow(2, n) возвращает double, приводим к int
    int result = pow(2, n).toInt();
    return '2^$n = $result';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Степени числа 2'),
        backgroundColor: const Color.fromARGB(255, 26, 54, 27),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          // index = 0 -> 2^0 = 1
          // index = 1 -> 2^1 = 2
          // index = 2 -> 2^2 = 4 и т.д.
          return ListTile(
            leading: Icon(Icons.calculate),
            title: Text(_calculatePower(index)),
            trailing: Text('${index + 1}', style: TextStyle(color: Colors.grey)),
          );
        },
      ),
    );
  }
}