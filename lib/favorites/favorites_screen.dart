import 'package:flutter/material.dart';
import 'package:garduation_h/details/details.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var favoritesBox = Hive.box('favorites');

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favorites',
          style: TextStyle(
              fontWeight: FontWeight.w800, fontSize: 20, color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: favoritesBox.listenable(),
        builder: (context, Box box, _) {
          if (box.values.isEmpty) {
            return const Center(
              child: Text(
                'No favorites yet!',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          var favorites = box.values.toList();

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: favorites.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              var person = Map<String, dynamic>.from(favorites[index]);
              return FavoriteItem(person: person);
            },
          );
        },
      ),
    );
  }
}

class FavoriteItem extends StatelessWidget {
  final Map<String, dynamic> person;

  const FavoriteItem({super.key, required this.person});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsScreen(
              id: person['id'],
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xffE0EBFF)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                person['profilePath'],
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[200],
                  child: const Icon(Icons.person),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                person['name'],
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                Hive.box('favorites').delete(person['id'].toString());
              },
              icon: const Icon(Icons.favorite, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
