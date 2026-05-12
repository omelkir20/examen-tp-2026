import 'package:flutter/material.dart';
import '../models/produit.dart';
import '../models/avis.dart';
import '../services/api_service.dart';

class AvisScreen extends StatelessWidget {
  final Produit produit;
  const AvisScreen({super.key, required this.produit});

  @override
  Widget build(BuildContext context) {
    final ApiService apiService = ApiService();

    return Scaffold(
      appBar: AppBar(
        title: Text('Avis — ${produit.nom}'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: FutureBuilder<List<Avis>>(
        future: apiService.getAvisByProduit(produit.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          }
          final avisList = snapshot.data!;
          if (avisList.isEmpty) {
            return const Center(child: Text('Aucun avis pour ce produit'));
          }
          return ListView.builder(
            itemCount: avisList.length,
            itemBuilder: (context, index) {
              final avis = avisList[index];
              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 6),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(avis.auteur,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                          Row(
                            children: List.generate(5, (i) => Icon(
                              i < avis.note
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.amber,
                              size: 18,
                            )),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(avis.commentaire),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}