import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Кофемашина v2',
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
// 1. ПЕРЕЧИСЛЕНИЕ ТИПОВ КОФЕ
// ==============================================
enum CoffeeType {
  espresso,
  americano,
  cappuccino,
  latte,
}

// ==============================================
// 2. ИНТЕРФЕЙС ICoffee (абстрактный класс)
// ==============================================
abstract class ICoffee {
  int coffee();   // граммы
  int milk();     // миллилитры
  int water();    // миллилитры
  int price();    // стоимость в рублях
}

// ==============================================
// 3. КОНКРЕТНЫЕ ВИДЫ КОФЕ (реализуют ICoffee)
// ==============================================
class Espresso implements ICoffee {
  @override
  int coffee() => 50;
  @override
  int milk() => 0;
  @override
  int water() => 100;
  @override
  int price() => 70;
}

class Americano implements ICoffee {
  @override
  int coffee() => 50;
  @override
  int milk() => 0;
  @override
  int water() => 150;
  @override
  int price() => 80;
}

class Cappuccino implements ICoffee {
  @override
  int coffee() => 50;
  @override
  int milk() => 100;
  @override
  int water() => 100;
  @override
  int price() => 120;
}

class Latte implements ICoffee {
  @override
  int coffee() => 50;
  @override
  int milk() => 150;
  @override
  int water() => 100;
  @override
  int price() => 130;
}

// ==============================================
// 4. КЛАСС УПРАВЛЕНИЯ РЕСУРСАМИ
// ==============================================
class Resources {
  int _coffeeBeans;   // граммы
  int _milk;          // миллилитры
  int _water;         // миллилитры
  int _cash;          // рубли

  Resources(this._coffeeBeans, this._milk, this._water, this._cash);

  // Геттеры
  int get coffee => _coffeeBeans;
  int get milk => _milk;
  int get water => _water;
  int get cash => _cash;

  // Пополнение ресурсов (сеттеры)
  void addCoffee(int amount) => _coffeeBeans += amount;
  void addMilk(int amount) => _milk += amount;
  void addWater(int amount) => _water += amount;
  void addCash(int amount) => _cash += amount;

  // Проверка, хватает ли ресурсов для конкретного кофе
  bool hasEnough(ICoffee coffee) {
    return _coffeeBeans >= coffee.coffee() &&
        _milk >= coffee.milk() &&
        _water >= coffee.water();
  }

  // Списание ресурсов (без проверки)
  void subtract(ICoffee coffee) {
    _coffeeBeans -= coffee.coffee();
    _milk -= coffee.milk();
    _water -= coffee.water();
  }

  // Внесение денег от продажи
  void earn(int amount) => _cash += amount;
}

// ==============================================
// 5. КЛАСС КОФЕМАШИНЫ (использует Resources и фабричный метод)
// ==============================================
class CoffeeMachine {
  final Resources _resources;

  CoffeeMachine(this._resources);

  // Фабричный метод: создаёт объект кофе по типу
  ICoffee _createCoffee(CoffeeType type) {
    switch (type) {
      case CoffeeType.espresso:
        return Espresso();
      case CoffeeType.americano:
        return Americano();
      case CoffeeType.cappuccino:
        return Cappuccino();
      case CoffeeType.latte:
        return Latte();
    }
  }

  // Приготовление выбранного кофе
  bool makeCoffee(CoffeeType type) {
    ICoffee coffee = _createCoffee(type);
    if (_resources.hasEnough(coffee)) {
      _resources.subtract(coffee);
      _resources.earn(coffee.price());
      return true;
    }
    return false;
  }

  // Доступ к ресурсам для отображения
  Resources get resources => _resources;
}

// ==============================================
// 6. FLUTTER-ИНТЕРФЕЙС
// ==============================================
class CoffeeMachineScreen extends StatefulWidget {
  const CoffeeMachineScreen({super.key});

  @override
  State<CoffeeMachineScreen> createState() => _CoffeeMachineScreenState();
}

class _CoffeeMachineScreenState extends State<CoffeeMachineScreen> {
  late CoffeeMachine _machine;
  late Resources _resources;
  String _log = '';

  // Контроллеры для добавления ресурсов
  final TextEditingController _coffeeController = TextEditingController();
  final TextEditingController _milkController = TextEditingController();
  final TextEditingController _waterController = TextEditingController();
  final TextEditingController _cashController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Начальные запасы: кофе 200 г, молоко 500 мл, вода 1000 мл, деньги 0 руб
    _resources = Resources(200, 500, 1000, 0);
    _machine = CoffeeMachine(_resources);
    _appendLog('Кофемашина готова! Начальные ресурсы: кофе 200 г, молоко 500 мл, вода 1000 мл, деньги 0 руб.');
  }

  void _appendLog(String message) {
    setState(() {
      _log += '$message\n';
    });
    print(message);
  }

  void _makeCoffee(CoffeeType type) {
    String typeName = type.toString().split('.').last;
    _appendLog('--- Заказ: $typeName ---');
    bool success = _machine.makeCoffee(type);
    if (success) {
      _appendLog('✅ $typeName приготовлен! Ресурсы списаны, деньги добавлены.');
    } else {
      _appendLog('❌ Недостаточно ресурсов для $typeName.');
    }
    _appendLog('');
    setState(() {});
  }

  void _addResources() {
    int coffeeAdd = int.tryParse(_coffeeController.text) ?? 0;
    int milkAdd = int.tryParse(_milkController.text) ?? 0;
    int waterAdd = int.tryParse(_waterController.text) ?? 0;
    int cashAdd = int.tryParse(_cashController.text) ?? 0;

    if (coffeeAdd > 0) _resources.addCoffee(coffeeAdd);
    if (milkAdd > 0) _resources.addMilk(milkAdd);
    if (waterAdd > 0) _resources.addWater(waterAdd);
    if (cashAdd > 0) _resources.addCash(cashAdd);

    _appendLog('--- Пополнение ресурсов ---');
    if (coffeeAdd > 0) _appendLog('+$coffeeAdd г кофе');
    if (milkAdd > 0) _appendLog('+$milkAdd мл молока');
    if (waterAdd > 0) _appendLog('+$waterAdd мл воды');
    if (cashAdd > 0) _appendLog('+$cashAdd руб внесено в автомат');
    _appendLog('');

    _coffeeController.clear();
    _milkController.clear();
    _waterController.clear();
    _cashController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Кофемашина (ООП + паттерны)'),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Карточка текущих ресурсов
            Card(
              color: Colors.brown.shade50,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('☕ Кофе: ${_resources.coffee} г', style: const TextStyle(fontSize: 16)),
                    Text('🥛 Молоко: ${_resources.milk} мл', style: const TextStyle(fontSize: 16)),
                    Text('💧 Вода: ${_resources.water} мл', style: const TextStyle(fontSize: 16)),
                    Text('💰 Деньги в автомате: ${_resources.cash} руб', style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Выбор кофе (горизонтальные кнопки)
            const Text('Выберите напиток:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _buildCoffeeButton(CoffeeType.espresso, 'Эспрессо', 70),
                _buildCoffeeButton(CoffeeType.americano, 'Американо', 80),
                _buildCoffeeButton(CoffeeType.cappuccino, 'Капучино', 120),
                _buildCoffeeButton(CoffeeType.latte, 'Латте', 130),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const Text('Пополнить ресурсы:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            // Поля ввода для пополнения
            Row(
              children: [
                Expanded(child: _buildResourceField(_coffeeController, 'Кофе (г)')),
                const SizedBox(width: 8),
                Expanded(child: _buildResourceField(_milkController, 'Молоко (мл)')),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _buildResourceField(_waterController, 'Вода (мл)')),
                const SizedBox(width: 8),
                Expanded(child: _buildResourceField(_cashController, 'Деньги (руб)')),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _addResources,
              child: const Text('Добавить выбранное'),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const Text('Лог операций:', style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: SingleChildScrollView(
                child: Text(_log, style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResourceField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildCoffeeButton(CoffeeType type, String name, int price) {
    return ElevatedButton(
      onPressed: () => _makeCoffee(type),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      child: Text('$name\n${price}₽', textAlign: TextAlign.center),
    );
  }

  @override
  void dispose() {
    _coffeeController.dispose();
    _milkController.dispose();
    _waterController.dispose();
    _cashController.dispose();
    super.dispose();
  }
}