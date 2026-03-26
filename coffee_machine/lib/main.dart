// main.dart
import 'package:flutter/material.dart';
import 'classes/machine.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Кофемашина',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Эмулятор кофемашины'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Machine myMachine = Machine(200, 500, 1000, 0);
                  
                  print('--- Состояние машины до приготовления ---');
                  print('Кофе: ${myMachine.coffeeBeans} г');
                  print('Молоко: ${myMachine.milk} мл');
                  print('Вода: ${myMachine.water} мл');
                  print('Деньги: ${myMachine.cash} руб.');
                  
                  myMachine.addCash = 100;
                  print('\nПользователь внес 100 руб.');
                  print('Денег в машине: ${myMachine.cash} руб.');
                  
                  print('\n--- Приготовление кофе ---');
                  bool isSuccess = myMachine.makingCoffee();
                  
                  print('\n--- Состояние машины после приготовления ---');
                  if (isSuccess) {
                    print('Кофе успешно приготовлен!');
                    print('Денег в машине: ${myMachine.cash} руб.');
                  } else {
                    print('Приготовление не удалось!');
                  }
                  print('Кофе: ${myMachine.coffeeBeans} г');
                  print('Вода: ${myMachine.water} мл');
                },
                child: Text('Приготовить эспрессо'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}