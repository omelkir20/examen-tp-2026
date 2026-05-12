import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/categorie.dart';
import '../models/produit.dart';
import '../models/avis.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8090'; // émulateur Android
  // Pour appareil physique, remplacez par l'IP de votre machine

  Future<List<Categorie>> getCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/api/categories'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Categorie.fromJson(e)).toList();
    }
    throw Exception('Erreur chargement catégories');
  }

  Future<List<Produit>> getProduitsByCategorie(int categorieId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/produits?categorieId=$categorieId'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Produit.fromJson(e)).toList();
    }
    throw Exception('Erreur chargement produits');
  }

  Future<List<Avis>> getAvisByProduit(int produitId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/avis/$produitId'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Avis.fromJson(e)).toList();
    }
    throw Exception('Erreur chargement avis');
  }
}