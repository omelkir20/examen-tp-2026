class Produit {
  final int id;
  final String nom;
  final double prix;
  final int stock;

  Produit({
    required this.id,
    required this.nom,
    required this.prix,
    required this.stock,
  });

  factory Produit.fromJson(Map<String, dynamic> json) {
    return Produit(
      id: json['id'],
      nom: json['nom'],
      prix: (json['prix'] as num).toDouble(),
      stock: json['stock'],
    );
  }
}