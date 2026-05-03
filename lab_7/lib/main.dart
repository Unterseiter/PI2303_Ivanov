import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Навигация',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const FirstScreen(),
    );
  }
}

// ==============================================
// ПЕРВЫЙ ЭКРАН (главный)
// ==============================================
class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  // Показываем уведомление с результатом
  void _showResult(BuildContext context, String choice) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Вы выбрали: $choice'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Первый экран'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Задать вопрос?',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Открываем второй экран и ждём результат
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SecondScreen()),
                );
                // result будет строкой 'Да' или 'Нет', если вернулись через кнопку
                if (result != null) {
                  _showResult(context, result);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Задать вопрос'),
            ),
          ],
        ),
      ),
    );
  }
}

// ==============================================
// ВТОРОЙ ЭКРАН (с выбором Да/Нет)
// ==============================================
class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Второй экран'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Вы уверены?',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Кнопка "Да"
                ElevatedButton(
                  onPressed: () {
                    // Возвращаем результат 'Да' на первый экран
                    Navigator.pop(context, 'Да');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  ),
                  child: const Text('Да'),
                ),
                const SizedBox(width: 20),
                // Кнопка "Нет"
                ElevatedButton(
                  onPressed: () {
                    // Возвращаем результат 'Нет' на первый экран
                    Navigator.pop(context, 'Нет');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  ),
                  child: const Text('Нет'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}