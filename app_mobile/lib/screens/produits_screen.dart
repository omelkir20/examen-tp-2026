import 'package:flutter/material.dart';
import '../models/categorie.dart';
import '../models/produit.dart';
import '../services/api_service.dart';
import 'avis_screen.dart';

const _categoryColors = {
  'Électronique': Color(0xFF6C63FF),
  'Vêtements':    Color(0xFFFF6584),
  'Livres':       Color(0xFF43C59E),
  'default':      Color(0xFFFFB347),
};

Color _colorFor(String nom) =>
    _categoryColors[nom] ?? _categoryColors['default']!;

class ProduitsScreen extends StatelessWidget {
  final Categorie categorie;
  const ProduitsScreen({super.key, required this.categorie});

  @override
  Widget build(BuildContext context) {
    final api = ApiService();
    final color = _colorFor(categorie.nom);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      body: SafeArea(
        child: FutureBuilder<List<Produit>>(
          future: api.getProduitsByCategorie(categorie.id),
          builder: (context, snapshot) {
            return CustomScrollView(
              slivers: [
                // ── AppBar custom ────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.06),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(Icons.arrow_back_rounded,
                              size: 20, color: Color(0xFF1A1A2E)),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(categorie.nom,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1A1A2E),
                              letterSpacing: -0.5,
                            )),
                        ),
                      ],
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 20)),

                // ── État chargement / erreur / vide ──────────────
                if (snapshot.connectionState == ConnectionState.waiting)
                  const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF6C63FF), strokeWidth: 2.5),
                    ),
                  )
                else if (snapshot.hasError)
                  SliverFillRemaining(
                    child: Center(
                      child: Text('Erreur : ${snapshot.error}',
                        style: const TextStyle(color: Color(0xFF6B7280))),
                    ),
                  )
                else if (snapshot.data!.isEmpty)
                  const SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.inventory_2_outlined,
                            size: 56, color: Color(0xFFD1D5DB)),
                          SizedBox(height: 12),
                          Text('Aucun produit disponible',
                            style: TextStyle(
                              color: Color(0xFF6B7280), fontSize: 15)),
                        ],
                      ),
                    ),
                  )
                else ...[
                  // ── Compteur produits ──────────────────────────
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${snapshot.data!.length} produit${snapshot.data!.length > 1 ? "s" : ""}',
                              style: TextStyle(
                                color: color,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 14)),

                  // ── Liste produits ─────────────────────────────
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return _ProduitCard(
                            produit: snapshot.data![index],
                            color: color,
                          );
                        },
                        childCount: snapshot.data!.length,
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 20)),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ProduitCard extends StatelessWidget {
  final Produit produit;
  final Color color;
  const _ProduitCard({required this.produit, required this.color});

  @override
  Widget build(BuildContext context) {
    final inStock = produit.stock > 0;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => AvisScreen(produit: produit)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.07),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icône produit
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(Icons.inventory_2_rounded,
                  color: color, size: 28),
              ),
              const SizedBox(width: 14),

              // Infos
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(produit.nom,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: Color(0xFF1A1A2E),
                      )),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          '${produit.prix.toStringAsFixed(2)} €',
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: inStock
                                ? const Color(0xFFE6F9F4)
                                : const Color(0xFFFFEDF1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            inStock ? 'Stock: ${produit.stock}' : 'Rupture',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: inStock
                                  ? const Color(0xFF43C59E)
                                  : const Color(0xFFFF6584),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Flèche
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.arrow_forward_rounded,
                  color: color, size: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
