import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Кофемашина (асинхронная)',
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
// ПЕРЕЧИСЛЕНИЕ ТИПОВ КОФЕ
// ==============================================
enum CoffeeType { espresso, americano, cappuccino, latte }

// ==============================================
// ИНТЕРФЕЙС ICoffee
// ==============================================
abstract class ICoffee {
  int coffee();   // граммы
  int milk();     // миллилитры
  int water();    // миллилитры
  int price();    // стоимость в рублях
  bool needMilk(); // нужен ли процесс взбивания молока
}

// ==============================================
// КОНКРЕТНЫЕ ВИДЫ КОФЕ
// ==============================================
class Espresso implements ICoffee {
  @override int coffee() => 50;
  @override int milk() => 0;
  @override int water() => 100;
  @override int price() => 70;
  @override bool needMilk() => false;
}

class Americano implements ICoffee {
  @override int coffee() => 50;
  @override int milk() => 0;
  @override int water() => 150;
  @override int price() => 80;
  @override bool needMilk() => false;
}

class Cappuccino implements ICoffee {
  @override int coffee() => 50;
  @override int milk() => 100;
  @override int water() => 100;
  @override int price() => 120;
  @override bool needMilk() => true;
}

class Latte implements ICoffee {
  @override int coffee() => 50;
  @override int milk() => 150;
  @override int water() => 100;
  @override int price() => 130;
  @override bool needMilk() => true;
}

// ==============================================
// КЛАСС УПРАВЛЕНИЯ РЕСУРСАМИ
// ==============================================
class Resources {
  int _coffeeBeans;
  int _milk;
  int _water;
  int _cash;

  Resources(this._coffeeBeans, this._milk, this._water, this._cash);

  int get coffee => _coffeeBeans;
  int get milk => _milk;
  int get water => _water;
  int get cash => _cash;

  void addCoffee(int amount) => _coffeeBeans += amount;
  void addMilk(int amount) => _milk += amount;
  void addWater(int amount) => _water += amount;
  void addCash(int amount) => _cash += amount;

  bool hasEnough(ICoffee coffee) {
    return _coffeeBeans >= coffee.coffee() &&
        _milk >= coffee.milk() &&
        _water >= coffee.water();
  }

  void subtract(ICoffee coffee) {
    _coffeeBeans -= coffee.coffee();
    _milk -= coffee.milk();
    _water -= coffee.water();
  }

  void earn(int amount) => _cash += amount;
}

// ==============================================
// АСИНХРОННЫЕ ОПЕРАЦИИ ПРИГОТОВЛЕНИЯ
// ==============================================
class CoffeeMaker {
  // Функция обратного вызова для вывода сообщений
  final Function(String) onLog;

  CoffeeMaker({required this.onLog});

  // Нагрев воды (3 секунды)
  Future<void> heatWater() async {
    onLog('🔥 Нагрев воды...');
    await Future.delayed(const Duration(seconds: 3));
    onLog('✅ Вода нагрета.');
  }

  // Заваривание кофе (5 секунд)
  Future<void> brewCoffee() async {
    onLog('☕ Заваривание кофе...');
    await Future.delayed(const Duration(seconds: 5));
    onLog('✅ Кофе заварен.');
  }

  // Взбивание молока (5 секунд)
  Future<void> frothMilk() async {
    onLog('🥛 Взбивание молока...');
    await Future.delayed(const Duration(seconds: 5));
    onLog('✅ Молоко готово.');
  }

  // Смешивание компонентов (3 секунды)
  Future<void> mixComponents() async {
    onLog('🔄 Смешивание компонентов...');
    await Future.delayed(const Duration(seconds: 3));
    onLog('✅ Напиток готов!');
  }

  // Полный асинхронный процесс приготовления в зависимости от кофе
  Future<void> makeFullProcess(ICoffee coffee) async {
    onLog('=== Начало приготовления ${coffee.runtimeType} ===');

    // 1. Нагрев воды
    await heatWater();

    // Заваривание и взбивание молока выполняются параллельно
    Future<void> brewFuture = brewCoffee();
    Future<void> milkFuture = coffee.needMilk() ? frothMilk() : Future.value();

    // Ждём завершения обоих процессов
    await Future.wait([brewFuture, milkFuture]);

    // 3. Смешивание
    await mixComponents();

    onLog('=== Приготовление завершено ===\n');
  }
}

// ==============================================
// КЛАСС КОФЕМАШИНЫ (с асинхронным приготовлением)
// ==============================================
class CoffeeMachine {
  final Resources _resources;
  final CoffeeMaker _maker;

  CoffeeMachine(this._resources, this._maker);

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

  // Асинхронное приготовление с проверкой ресурсов
  Future<bool> makeCoffee(CoffeeType type) async {
    ICoffee coffee = _createCoffee(type);
    if (_resources.hasEnough(coffee)) {
      // Списываем ресурсы сразу (можно и после приготовления, но списание до процесса логичнее)
      _resources.subtract(coffee);
      _resources.earn(coffee.price());

      // Запускаем асинхронный процесс приготовления
      await _maker.makeFullProcess(coffee);
      return true;
    } else {
      _maker.onLog('❌ Недостаточно ресурсов для ${coffee.runtimeType}');
      return false;
    }
  }

  Resources get resources => _resources;
}

// ==============================================
// FLUTTER-ИНТЕРФЕЙС
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
  bool _isProcessing = false; // для блокировки кнопок во время готовки

  final TextEditingController _coffeeController = TextEditingController();
  final TextEditingController _milkController = TextEditingController();
  final TextEditingController _waterController = TextEditingController();
  final TextEditingController _cashController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _resources = Resources(200, 500, 1000, 0);
    // Создаём CoffeeMaker с callback для логирования
    final maker = CoffeeMaker(onLog: (msg) => _appendLog(msg));
    _machine = CoffeeMachine(_resources, maker);
    _appendLog('Кофемашина готова (асинхронная).');
  }

  void _appendLog(String message) {
    setState(() {
      _log += '$message\n';
    });
    print(message);
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
    if (cashAdd > 0) _appendLog('+$cashAdd руб');
    _appendLog('');

    _coffeeController.clear();
    _milkController.clear();
    _waterController.clear();
    _cashController.clear();
    setState(() {});
  }

  Future<void> _makeCoffee(CoffeeType type) async {
    if (_isProcessing) {
      _appendLog('⚠️ Подождите, машина уже готовит...');
      return;
    }
    setState(() => _isProcessing = true);
    String typeName = type.toString().split('.').last;
    _appendLog('--- Заказ: $typeName ---');
    bool success = await _machine.makeCoffee(type);
    if (success) {
      _appendLog('💰 Стоимость: ${_getCoffeePrice(type)} руб.');
      _appendLog('✅ $typeName успешно приготовлен!');
    } else {
      _appendLog('❌ Не удалось приготовить $typeName.');
    }
    setState(() => _isProcessing = false);
  }

  int _getCoffeePrice(CoffeeType type) {
    switch (type) {
      case CoffeeType.espresso: return 70;
      case CoffeeType.americano: return 80;
      case CoffeeType.cappuccino: return 120;
      case CoffeeType.latte: return 130;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Кофемашина (асинхронная)'),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              color: Colors.brown.shade50,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('☕ Кофе: ${_resources.coffee} г'),
                    Text('🥛 Молоко: ${_resources.milk} мл'),
                    Text('💧 Вода: ${_resources.water} мл'),
                    Text('💰 Деньги: ${_resources.cash} руб'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
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
            if (_isProcessing)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: LinearProgressIndicator(),
              ),
            const SizedBox(height: 12),
            const Divider(),
            const Text('Пополнить ресурсы:'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _buildField(_coffeeController, 'Кофе (г)')),
                const SizedBox(width: 8),
                Expanded(child: _buildField(_milkController, 'Молоко (мл)')),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _buildField(_waterController, 'Вода (мл)')),
                const SizedBox(width: 8),
                Expanded(child: _buildField(_cashController, 'Деньги (руб)')),
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

  Widget _buildField(TextEditingController controller, String label) {
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
      onPressed: _isProcessing ? null : () => _makeCoffee(type),
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