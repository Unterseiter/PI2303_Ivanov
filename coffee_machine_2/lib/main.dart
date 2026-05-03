import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Кофемашина',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        useMaterial3: true,
      ),
      home: const CoffeeMachineScreen(),
    );
  }
}

// ==============================================
// КЛАСС КОФЕМАШИНЫ (по UML из методички)
// ==============================================
class Machine {
  // Закрытые поля (private)
  int _coffeeBeans;   // граммы
  int _milk;          // миллилитры
  int _water;         // миллилитры
  int _cash;          // рубли

  // Конструктор
  Machine(this._coffeeBeans, this._milk, this._water, this._cash);

  // Геттеры (только чтение)
  int get coffeeBeans => _coffeeBeans;
  int get milk => _milk;
  int get water => _water;
  int get cash => _cash;

  // Сеттеры (с проверкой — только добавление)
  set addCoffeeBeans(int amount) {
    if (amount > 0) _coffeeBeans += amount;
  }
  set addMilk(int amount) {
    if (amount > 0) _milk += amount;
  }
  set addWater(int amount) {
    if (amount > 0) _water += amount;
  }
  set addCash(int amount) {
    if (amount > 0) _cash += amount;
  }

  // Приватный метод проверки ресурсов
  bool _isAvailable(int coffeeNeeded, int waterNeeded) {
    if (_coffeeBeans >= coffeeNeeded && _water >= waterNeeded) {
      return true;
    } else {
      if (_coffeeBeans < coffeeNeeded) print('❌ Недостаточно кофе!');
      if (_water < waterNeeded) print('❌ Недостаточно воды!');
      return false;
    }
  }

  // Приватный метод списания ресурсов (эспрессо)
  void _subtractResources(int coffee, int water) {
    _coffeeBeans -= coffee;
    _water -= water;
    // молоко не тратится на эспрессо
  }

  // Публичный метод приготовления кофе (только эспрессо)
  bool makingCoffee() {
    const int coffeeNeeded = 50;
    const int waterNeeded = 100;

    if (_isAvailable(coffeeNeeded, waterNeeded)) {
      _subtractResources(coffeeNeeded, waterNeeded);
      // Условно берём деньги за кофе (50 руб)
      _cash += 50;
      print('✅ Эспрессо приготовлен! Списан кофе: $coffeeNeeded г, вода: $waterNeeded мл.');
      print('💰 Взято 50 руб. Баланс автомата: $_cash руб.');
      return true;
    } else {
      print('❌ Не удалось приготовить эспрессо. Пополните запасы.');
      return false;
    }
  }

  // Метод для вывода состояния (для отладки)
  void printState() {
    print('--- Состояние кофемашины ---');
    print('☕ Кофе: $_coffeeBeans г');
    print('🥛 Молоко: $_milk мл');
    print('💧 Вода: $_water мл');
    print('💰 Деньги: $_cash руб');
    print('------------------------------');
  }
}

// ==============================================
// ЭКРАН ПРИЛОЖЕНИЯ (Flutter-обёртка)
// ==============================================
class CoffeeMachineScreen extends StatefulWidget {
  const CoffeeMachineScreen({super.key});

  @override
  State<CoffeeMachineScreen> createState() => _CoffeeMachineScreenState();
}

class _CoffeeMachineScreenState extends State<CoffeeMachineScreen> {
  // Создаём объект кофемашины с начальными ресурсами
  late Machine _machine;
  final TextEditingController _addCoffeeController = TextEditingController();
  final TextEditingController _addWaterController = TextEditingController();
  final TextEditingController _addMilkController = TextEditingController();
  final TextEditingController _addCashController = TextEditingController();

  // Для вывода сообщений в интерфейсе
  String _log = '';

  @override
  void initState() {
    super.initState();
    _machine = Machine(200, 500, 1000, 0);
    _appendLog('Кофемашина создана: кофе 200 г, молоко 500 мл, вода 1000 мл, деньги 0 руб.');
    _machine.printState();
  }

  void _appendLog(String message) {
    setState(() {
      _log += '$message\n';
    });
    print(message); // дублируем в консоль
  }

  void _makeCoffee() {
    _appendLog('--- Попытка приготовить эспрессо ---');
    bool success = _machine.makingCoffee();
    if (success) {
      _appendLog('Результат: эспрессо готов!');
    } else {
      _appendLog('Результат: ошибка — недостаточно ресурсов.');
    }
    _appendLog('');
    _machine.printState();
    setState(() {}); // обновляем UI
  }

  void _addResource() {
    int coffeeAdd = int.tryParse(_addCoffeeController.text) ?? 0;
    int waterAdd = int.tryParse(_addWaterController.text) ?? 0;
    int milkAdd = int.tryParse(_addMilkController.text) ?? 0;
    int cashAdd = int.tryParse(_addCashController.text) ?? 0;

    if (coffeeAdd > 0) _machine.addCoffeeBeans = coffeeAdd;
    if (waterAdd > 0) _machine.addWater = waterAdd;
    if (milkAdd > 0) _machine.addMilk = milkAdd;
    if (cashAdd > 0) _machine.addCash = cashAdd;

    _appendLog('--- Пополнение ресурсов ---');
    if (coffeeAdd > 0) _appendLog('Добавлено кофе: +$coffeeAdd г');
    if (waterAdd > 0) _appendLog('Добавлено воды: +$waterAdd мл');
    if (milkAdd > 0) _appendLog('Добавлено молока: +$milkAdd мл');
    if (cashAdd > 0) _appendLog('Добавлено денег: +$cashAdd руб');
    _appendLog('');
    _machine.printState();

    _addCoffeeController.clear();
    _addWaterController.clear();
    _addMilkController.clear();
    _addCashController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Кофемашина (ООП)'),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Отображение текущих ресурсов
            Card(
              color: Colors.brown.shade50,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('☕ Кофе: ${_machine.coffeeBeans} г', style: const TextStyle(fontSize: 16)),
                    Text('🥛 Молоко: ${_machine.milk} мл', style: const TextStyle(fontSize: 16)),
                    Text('💧 Вода: ${_machine.water} мл', style: const TextStyle(fontSize: 16)),
                    Text('💰 Деньги: ${_machine.cash} руб', style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Кнопка приготовить кофе
            ElevatedButton.icon(
              onPressed: _makeCoffee,
              icon: const Icon(Icons.coffee),
              label: const Text('Приготовить эспрессо'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const Text('Пополнить ресурсы:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _addCoffeeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Кофе (г)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _addWaterController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Вода (мл)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _addMilkController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Молоко (мл)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _addCashController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Деньги (руб)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _addResource,
              child: const Text('Добавить выбранное'),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const Text('Лог операций:', style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _log,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _addCoffeeController.dispose();
    _addWaterController.dispose();
    _addMilkController.dispose();
    _addCashController.dispose();
    super.dispose();
  }
}