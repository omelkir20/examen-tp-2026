import 'package:flutter/material.dart';
import '../models/categorie.dart';
import '../models/produit.dart';
import '../services/api_service.dart';
import 'avis_screen.dart';

class ProduitsScreen extends StatelessWidget {
  final Categorie categorie;
  const ProduitsScreen({super.key, required this.categorie});

  @override
  Widget build(BuildContext context) {
    final ApiService apiService = ApiService();

    return Scaffold(
      appBar: AppBar(
        title: Text(categorie.nom),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: FutureBuilder<List<Produit>>(
        future: apiService.getProduitsByCategorie(categorie.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          }
          final produits = snapshot.data!;
          if (produits.isEmpty) {
            return const Center(child: Text('Aucun produit'));
          }
          return ListView.builder(
            itemCount: produits.length,
            itemBuilder: (context, index) {
              final p = produits[index];
              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(p.nom,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${p.prix.toStringAsFixed(2)} € — Stock: ${p.stock}'),
                  trailing: const Icon(Icons.star_border),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AvisScreen(produit: p),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}