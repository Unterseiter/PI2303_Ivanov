
class Machine {
  int _coffeeBeans;
  int _milk;
  int _water;
  int _cash;

  Machine(this._coffeeBeans, this._milk, this._water, this._cash);

  int get coffeeBeans => _coffeeBeans;
  int get milk => _milk;
  int get water => _water;
  int get cash => _cash;

  set addCash(int amount) {
    if (amount > 0) {
      _cash += amount;
    }
  }

  set addCoffeeBeans(int amount) {
    if (amount > 0) {
      _coffeeBeans += amount;
    }
  }
  set addMilk(int amount) {
    if (amount > 0) {
      _milk += amount;
    }
  }
  set addWater(int amount) {
    if (amount > 0) {
      _water += amount;
    }
  }


  bool _isAvailable(int coffeeNeeded, int waterNeeded) {
    if (_coffeeBeans >= coffeeNeeded && _water >= waterNeeded) {
      return true;
    } else {
      if (_coffeeBeans < coffeeNeeded) print('Недостаточно кофе!');
      if (_water < waterNeeded) print('Недостаточно воды!');
      return false;
    }
  }

  void _subtractResources(int coffee, int milk, int water) {
    _coffeeBeans -= coffee;
    _milk -= milk;
    _water -= water;
  }

  bool makingCoffee() {
    const int coffeeNeeded = 50; // грамм
    const int waterNeeded = 100; // мл

    if (_isAvailable(coffeeNeeded, waterNeeded)) {
      _subtractResources(coffeeNeeded, 0, waterNeeded);
      print('Эспрессо готов!');
      return true;
    } else {
      print('Не могу приготовить эспрессо.');
      return false;
    }
  }
}