import 'package:flutter/material.dart';
import '../models/categorie.dart';
import '../services/api_service.dart';
import 'produits_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final ApiService _apiService = ApiService();
  Categorie? _selectedCategorie;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Boutique — Catégories'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: FutureBuilder<List<Categorie>>(
        future: _apiService.getCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          }
          final categories = snapshot.data!;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: DropdownButtonFormField<Categorie>(
                  decoration: const InputDecoration(
                    labelText: 'Sélectionnez une catégorie',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedCategorie,
                  items: categories.map((cat) {
                    return DropdownMenuItem<Categorie>(
                      value: cat,
                      child: Text(cat.nom),
                    );
                  }).toList(),
                  onChanged: (cat) {
                    setState(() => _selectedCategorie = cat);
                    if (cat != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProduitsScreen(categorie: cat),
                        ),
                      );
                    }
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    return ListTile(
                      leading: const Icon(Icons.category),
                      title: Text(cat.nom),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProduitsScreen(categorie: cat),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}