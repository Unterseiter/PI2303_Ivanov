import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Лабораторная работа №8',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MainMenuScreen(),
    );
  }
}

// ==============================================
// ГЛАВНЫЙ ЭКРАН (выбор: Фотогалерея или Новости)
// ==============================================
class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Лабораторная работа №8'),
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
                  MaterialPageRoute(builder: (context) => const PhotoGalleryScreen()),
                );
              },
              child: const Text('1. Фотогалерея (JSONPlaceholder)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NewsFeedScreen()),
                );
              },
              child: const Text('2. Новостная лента КубГАУ'),
            ),
          ],
        ),
      ),
    );
  }
}

// ==============================================
// ЧАСТЬ 1: ФОТОГАЛЕРЕЯ (сетка из 2 колонок)
// ==============================================

// Модель данных для фотографии
class Photo {
  final int albumId;
  final int id;
  final String title;
  final String url;
  final String thumbnailUrl;

  const Photo({
    required this.albumId,
    required this.id,
    required this.title,
    required this.url,
    required this.thumbnailUrl,
  });

  // Фабричный конструктор: создаёт Photo из JSON
  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      albumId: json['albumId'] as int,
      id: json['id'] as int,
      title: json['title'] as String,
      url: json['url'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
    );
  }
}

// Сервис для получения фотографий
Future<List<Photo>> fetchPhotos() async {
  final response = await http.get(
    Uri.parse('https://jsonplaceholder.typicode.com/photos'),
  );

  if (response.statusCode == 200) {
    List jsonResponse = jsonDecode(response.body);
    return jsonResponse.map((photo) => Photo.fromJson(photo)).toList();
  } else {
    throw Exception('Ошибка загрузки фотографий');
  }
}

// Экран фотогалереи
class PhotoGalleryScreen extends StatelessWidget {
  const PhotoGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Фотогалерея'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Photo>>(
        future: fetchPhotos(),
        builder: (context, snapshot) {
          // Показываем индикатор загрузки
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // Обрабатываем ошибку
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 50, color: Colors.red),
                  const SizedBox(height: 10),
                  Text('Ошибка: ${snapshot.error}'),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Перезагружаем страницу
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const PhotoGalleryScreen()),
                      );
                    },
                    child: const Text('Повторить'),
                  ),
                ],
              ),
            );
          }
          // Данные загружены — показываем сетку
          if (snapshot.hasData) {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,        // 2 колонки
                crossAxisSpacing: 4,      // отступ между колонками
                mainAxisSpacing: 4,       // отступ между строками
                childAspectRatio: 1.0,    // квадратные ячейки
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final photo = snapshot.data![index];
                return Image.network(
                  photo.thumbnailUrl,
                  fit: BoxFit.cover,
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

// ==============================================
// ЧАСТЬ 2: НОВОСТИ КУБГАУ (зелёная тема, карточки)
// ==============================================

// Модель данных для новости
class NewsItem {
  final String title;
  final String description;
  final String date;
  final String link;

  NewsItem({
    required this.title,
    required this.description,
    required this.date,
    required this.link,
  });

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      title: json['title']?.toString() ?? 'Без названия',
      description: json['description']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      link: json['link']?.toString() ?? '',
    );
  }
}

// Сервис для получения новостей
Future<List<NewsItem>> fetchNews() async {
  final apiKey = '6df2f5d38d4e16b5a923a6d4873e2ee295d0ac90';
  final url = 'https://kubsau.ru/api/getNews.php?key=$apiKey';
  
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonData = jsonDecode(response.body);
    
    if (jsonData.containsKey('news') && jsonData['news'] is List) {
      List newsList = jsonData['news'];
      return newsList.map((item) => NewsItem.fromJson(item)).toList();
    } else {
      return [];
    }
  } else {
    throw Exception('Ошибка загрузки новостей');
  }
}

// Экран новостной ленты
class NewsFeedScreen extends StatelessWidget {
  const NewsFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Лента новостей КубГАУ'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<NewsItem>>(
        future: fetchNews(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 50, color: Colors.red),
                  const SizedBox(height: 10),
                  Text('Ошибка: ${snapshot.error}'),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const NewsFeedScreen()),
                      );
                    },
                    child: const Text('Повторить'),
                  ),
                ],
              ),
            );
          }
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final news = snapshot.data![index];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    onTap: () {
                      // При нажатии показываем уведомление (можно открыть ссылку)
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Открыть: ${news.title}'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            news.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            news.description,
                            style: const TextStyle(fontSize: 14, color: Colors.grey),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today, size: 14, color: Colors.green),
                              const SizedBox(width: 4),
                              Text(
                                news.date,
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: Text('Новостей не найдено'));
        },
      ),
    );
  }
}