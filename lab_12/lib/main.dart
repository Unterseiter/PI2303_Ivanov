import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// ==============================================
// ГЛОБАЛЬНЫЕ ТИПЫ И КЛАССЫ (ООП, интерфейсы)
// ==============================================

enum CoffeeType { espresso, americano, cappuccino, latte }

abstract class ICoffee {
  int coffee();
  int milk();
  int water();
  int price();
  bool needMilk();
  String name();
}

class Espresso implements ICoffee {
  @override int coffee() => 50;
  @override int milk() => 0;
  @override int water() => 100;
  @override int price() => 70;
  @override bool needMilk() => false;
  @override String name() => 'Эспрессо';
}

class Americano implements ICoffee {
  @override int coffee() => 50;
  @override int milk() => 0;
  @override int water() => 150;
  @override int price() => 80;
  @override bool needMilk() => false;
  @override String name() => 'Американо';
}

class Cappuccino implements ICoffee {
  @override int coffee() => 50;
  @override int milk() => 100;
  @override int water() => 100;
  @override int price() => 120;
  @override bool needMilk() => true;
  @override String name() => 'Капучино';
}

class Latte implements ICoffee {
  @override int coffee() => 50;
  @override int milk() => 150;
  @override int water() => 100;
  @override int price() => 130;
  @override bool needMilk() => true;
  @override String name() => 'Латте';
}

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

// Асинхронный приготовитель
class CoffeeMaker {
  final Function(String) onLog;
  CoffeeMaker({required this.onLog});

  Future<void> heatWater() async {
    onLog('🔥 Нагрев воды...');
    await Future.delayed(const Duration(seconds: 2));
    onLog('✅ Вода нагрета.');
  }

  Future<void> brewCoffee() async {
    onLog('☕ Заваривание кофе...');
    await Future.delayed(const Duration(seconds: 3));
    onLog('✅ Кофе заварен.');
  }

  Future<void> frothMilk() async {
    onLog('🥛 Взбивание молока...');
    await Future.delayed(const Duration(seconds: 3));
    onLog('✅ Молоко готово.');
  }

  Future<void> mixComponents() async {
    onLog('🔄 Смешивание...');
    await Future.delayed(const Duration(seconds: 2));
    onLog('✅ Напиток готов!');
  }

  Future<void> makeFullProcess(ICoffee coffee) async {
    onLog('=== Начало приготовления ${coffee.name()} ===');
    await heatWater();
    Future<void> brewFuture = brewCoffee();
    Future<void> milkFuture = coffee.needMilk() ? frothMilk() : Future.value();
    await Future.wait([brewFuture, milkFuture]);
    await mixComponents();
    onLog('=== Приготовление завершено ===\n');
  }
}

class CoffeeMachine {
  final Resources _resources;
  final CoffeeMaker _maker;

  CoffeeMachine(this._resources, this._maker);

  ICoffee _createCoffee(CoffeeType type) {
    switch (type) {
      case CoffeeType.espresso: return Espresso();
      case CoffeeType.americano: return Americano();
      case CoffeeType.cappuccino: return Cappuccino();
      case CoffeeType.latte: return Latte();
    }
  }

  Future<bool> makeCoffee(CoffeeType type) async {
    ICoffee coffee = _createCoffee(type);
    if (_resources.hasEnough(coffee)) {
      _resources.subtract(coffee);
      _resources.earn(coffee.price());
      await _maker.makeFullProcess(coffee);
      return true;
    } else {
      _maker.onLog('❌ Недостаточно ресурсов для ${coffee.name()}');
      return false;
    }
  }

  Resources get resources => _resources;
}

// ==============================================
// ГЛАВНОЕ ПРИЛОЖЕНИЕ С ВКЛАДКАМИ
// ==============================================
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Кофемашина Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

// Главный экран с вкладками (TabBar)
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late CoffeeMachine _coffeeMachine;
  late Resources _resources;
  final List<String> _logs = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _resources = Resources(200, 500, 1000, 0);
    final maker = CoffeeMaker(onLog: (msg) => _addLog(msg));
    _coffeeMachine = CoffeeMachine(_resources, maker);
    _addLog('Кофемашина запущена. Ресурсы: кофе 200г, молоко 500мл, вода 1000мл, деньги 0₽');
  }

  void _addLog(String message) {
    setState(() {
      _logs.insert(0, message); // новые сообщения сверху
      if (_logs.length > 50) _logs.removeLast();
    });
    print(message);
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Обновление ресурсов (вызывается из дочерних виджетов)
  void _refresh() {
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Кофемашина Pro'),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.coffee), text: 'Приготовление'),
            Tab(icon: Icon(Icons.settings), text: 'Управление'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Вкладка 1: Приготовление
          BrewTab(
            coffeeMachine: _coffeeMachine,
            resources: _resources,
            onLog: _addLog,
            onShowSnackBar: _showSnackBar,
            onRefresh: _refresh,
          ),
          // Вкладка 2: Управление ресурсами
          ManageTab(
            resources: _resources,
            onLog: _addLog,
            onShowSnackBar: _showSnackBar,
            onRefresh: _refresh,
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 120,
        color: Colors.brown.shade50,
        child: Column(
          children: [
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildResourceChip('☕', _resources.coffee.toString(), 'г'),
                  _buildResourceChip('🥛', _resources.milk.toString(), 'мл'),
                  _buildResourceChip('💧', _resources.water.toString(), 'мл'),
                  _buildResourceChip('💰', _resources.cash.toString(), '₽'),
                ],
              ),
            ),
            const Text('Лог последних операций:', style: TextStyle(fontSize: 12)),
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: _logs.length > 3 ? 3 : _logs.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      _logs[index],
                      style: const TextStyle(fontSize: 10, fontFamily: 'monospace'),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResourceChip(String icon, String value, String unit) {
    return Chip(
      avatar: Text(icon),
      label: Text('$value $unit'),
      backgroundColor: Colors.white,
    );
  }
}

// ==============================================
// ВКЛАДКА 1: ПРИГОТОВЛЕНИЕ
// ==============================================
class BrewTab extends StatefulWidget {
  final CoffeeMachine coffeeMachine;
  final Resources resources;
  final Function(String) onLog;
  final Function(String, {bool isError}) onShowSnackBar;
  final VoidCallback onRefresh;

  const BrewTab({
    super.key,
    required this.coffeeMachine,
    required this.resources,
    required this.onLog,
    required this.onShowSnackBar,
    required this.onRefresh,
  });

  @override
  State<BrewTab> createState() => _BrewTabState();
}

class _BrewTabState extends State<BrewTab> {
  bool _isProcessing = false;

  Future<void> _makeCoffee(CoffeeType type) async {
    if (_isProcessing) {
      widget.onShowSnackBar('Машина уже готовит, подождите...', isError: true);
      return;
    }
    setState(() => _isProcessing = true);
    String typeName = type.toString().split('.').last;
    widget.onLog('--- Заказ: $typeName ---');
    bool success = await widget.coffeeMachine.makeCoffee(type);
    widget.onRefresh();
    if (success) {
      widget.onShowSnackBar('$typeName приготовлен! Приятного аппетита!');
    } else {
      widget.onShowSnackBar('Недостаточно ресурсов для $typeName', isError: true);
    }
    setState(() => _isProcessing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Дисплей ресурсов (дублируется, но можно убрать, т.к. есть внизу)
          Card(
            color: Colors.brown.shade50,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  const Text('📊 Текущие ресурсы', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildResourceDisplay('☕', widget.resources.coffee, 'г'),
                      _buildResourceDisplay('🥛', widget.resources.milk, 'мл'),
                      _buildResourceDisplay('💧', widget.resources.water, 'мл'),
                      _buildResourceDisplay('💰', widget.resources.cash, '₽'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Выберите напиток:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              _buildCoffeeButton(CoffeeType.espresso, 'Эспрессо', 70, Icons.coffee),
              _buildCoffeeButton(CoffeeType.americano, 'Американо', 80, Icons.coffee),
              _buildCoffeeButton(CoffeeType.cappuccino, 'Капучино', 120, Icons.local_cafe),
              _buildCoffeeButton(CoffeeType.latte, 'Латте', 130, Icons.local_cafe),
            ],
          ),
          if (_isProcessing)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: LinearProgressIndicator(),
            ),
        ],
      ),
    );
  }

  Widget _buildResourceDisplay(String icon, int value, String unit) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 24)),
        Text('$value $unit', style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildCoffeeButton(CoffeeType type, String name, int price, IconData icon) {
    return SizedBox(
      width: 140,
      height: 80,
      child: ElevatedButton.icon(
        onPressed: _isProcessing ? null : () => _makeCoffee(type),
        icon: Icon(icon, size: 28),
        label: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(name, style: const TextStyle(fontSize: 16)),
            Text('$price₽', style: const TextStyle(fontSize: 12)),
          ],
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.brown,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}

// ==============================================
// ВКЛАДКА 2: УПРАВЛЕНИЕ РЕСУРСАМИ
// ==============================================
class ManageTab extends StatefulWidget {
  final Resources resources;
  final Function(String) onLog;
  final Function(String, {bool isError}) onShowSnackBar;
  final VoidCallback onRefresh;

  const ManageTab({
    super.key,
    required this.resources,
    required this.onLog,
    required this.onShowSnackBar,
    required this.onRefresh,
  });

  @override
  State<ManageTab> createState() => _ManageTabState();
}

class _ManageTabState extends State<ManageTab> {
  final TextEditingController _coffeeController = TextEditingController();
  final TextEditingController _milkController = TextEditingController();
  final TextEditingController _waterController = TextEditingController();
  final TextEditingController _cashController = TextEditingController();

  void _addResources() {
    int coffeeAdd = int.tryParse(_coffeeController.text) ?? 0;
    int milkAdd = int.tryParse(_milkController.text) ?? 0;
    int waterAdd = int.tryParse(_waterController.text) ?? 0;
    int cashAdd = int.tryParse(_cashController.text) ?? 0;

    if (coffeeAdd > 0) widget.resources.addCoffee(coffeeAdd);
    if (milkAdd > 0) widget.resources.addMilk(milkAdd);
    if (waterAdd > 0) widget.resources.addWater(waterAdd);
    if (cashAdd > 0) widget.resources.addCash(cashAdd);

    widget.onLog('--- Пополнение ресурсов ---');
    if (coffeeAdd > 0) widget.onLog('+$coffeeAdd г кофе');
    if (milkAdd > 0) widget.onLog('+$milkAdd мл молока');
    if (waterAdd > 0) widget.onLog('+$waterAdd мл воды');
    if (cashAdd > 0) widget.onLog('+$cashAdd руб');
    widget.onRefresh();

    widget.onShowSnackBar('Ресурсы успешно добавлены');
    _coffeeController.clear();
    _milkController.clear();
    _waterController.clear();
    _cashController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Card(
            color: Colors.brown.shade50,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  const Text('⚙️ Панель управления ресурсами', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  _buildTextField(_coffeeController, 'Кофе (г)', Icons.coffee),
                  const SizedBox(height: 12),
                  _buildTextField(_milkController, 'Молоко (мл)', Icons.local_drink),
                  const SizedBox(height: 12),
                  _buildTextField(_waterController, 'Вода (мл)', Icons.water_drop),
                  const SizedBox(height: 12),
                  _buildTextField(_cashController, 'Деньги (руб)', Icons.attach_money),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _addResources,
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text('Добавить выбранное'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 45),
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

  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
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