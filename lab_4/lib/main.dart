import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Общежитие КубГАУ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const DormCardPage(),
    );
  }
}

class DormCardPage extends StatefulWidget {
  const DormCardPage({super.key});

  @override
  State<DormCardPage> createState() => _DormCardPageState();
}

class _DormCardPageState extends State<DormCardPage> {
  bool _isLiked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Общежития КубГАУ'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 0,  // Убираем тень
      ),
      
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 4,  // Тень
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: Image.asset(
                    'assets/obshaga.jpg',
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // Если картинка не загрузится, показываем заглушку
                      return Container(
                        height: 200,
                        color: Colors.green[100],
                        child: const Center(
                          child: Icon(Icons.home, size: 50, color: Colors.green),
                        ),
                      );
                    },
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Заголовок
                      const Text(
                        'Студенческий городок КубГАУ',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // Адрес
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 18, color: Colors.green[600]),
                          const SizedBox(width: 4),
                          const Text(
                            'г. Краснодар, ул. Калинина, 13',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      
                      Row(
                        children: [
                          Icon(Icons.business, size: 18, color: Colors.green[600]),
                          const SizedBox(width: 4),
                          const Text(
                            '20 общежитий • более 8000 студентов',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          _showSnackBar(context, 'Звонок в деканат...');
                        },
                        icon: Icon(Icons.phone, color: Colors.green[600]),
                        iconSize: 30,
                      ),
                      const Text('Позвонить', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          _showSnackBar(context, 'Построение маршрута...');
                        },
                        icon: Icon(Icons.directions, color: Colors.green[600]),
                        iconSize: 30,
                      ),
                      const Text('Маршрут', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          _showSnackBar(context, 'Открыть шару...');
                        },
                        icon: Icon(Icons.share, color: Colors.green[600]),
                        iconSize: 30,
                      ),
                      const Text('Поделиться', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _isLiked = !_isLiked;
                          });
                          _showSnackBar(
                            context, 
                            _isLiked ? 'Вы поставили лайк!' : 'Вы убрали лайк',
                          );
                        },
                        icon: Icon(
                          _isLiked ? Icons.favorite : Icons.favorite_border,
                          color: Colors.red, 
                        ),
                        iconSize: 30,
                      ),
                      Text(
                        _isLiked ? 'Нравится' : 'Лайк',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'О студенческом городке',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(),  
                  
                  const Text(
                    'Студенческий городок или так называемый кампус Кубанского ГАУ состоит '
                    'из двадцати общежитий, в которых проживает более 8000 студентов, что '
                    'составляет 96% от всех нуждающихся.\n\n'
                    'Студенты первого курса обеспечены местами в общежитии полностью. '
                    'В соответствии с Положением о студенческих общежитиях университета, '
                    'при поселении между администрацией и студентами заключается договор '
                    'найма жилого помещения.\n\n'
                    'Воспитательная работа в общежитиях направлена на улучшение быта, '
                    'соблюдение правил внутреннего распорядка, отсутствия асоциальных '
                    'явлений в молодежной среде.\n\n'
                    'Условия проживания в общежитиях университетского кампуса полностью '
                    'отвечают санитарным нормам и требованиям: наличие оборудованных кухонь, '
                    'душевых комнат, прачечных, читальных залов, комнат самоподготовки, '
                    'помещений для заседаний студенческих советов и наглядной агитации.\n\n'
                    'С целью улучшения условий быта студентов активно работает система '
                    'студенческого самоуправления - студенческие советы организуют всю '
                    'работу по самообслуживанию.',
                    style: TextStyle(fontSize: 14, height: 1.5),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.green,
      ),
    );
  }
}