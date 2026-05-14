import 'package:flutter/material.dart';
import '../models/produit.dart';
import '../models/avis.dart';
import '../services/api_service.dart';

class AvisScreen extends StatelessWidget {
  final Produit produit;
  const AvisScreen({super.key, required this.produit});

  @override
  Widget build(BuildContext context) {
    final api = ApiService();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      body: SafeArea(
        child: FutureBuilder<List<Avis>>(
          future: api.getAvisByProduit(produit.id),
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
                        const Text('Avis clients',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1A1A2E),
                            letterSpacing: -0.5,
                          )),
                      ],
                    ),
                  ),
                ),

                // ── Carte produit ────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6C63FF), Color(0xFF9B8FF7)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.inventory_2_rounded,
                              color: Colors.white, size: 26),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(produit.nom,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  )),
                                const SizedBox(height: 4),
                                Text(
                                  '${produit.prix.toStringAsFixed(2)} €  •  Stock: ${produit.stock}',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  )),
                              ],
                            ),
                          ),
                        ],
                      ),
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
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.rate_review_outlined,
                              size: 60, color: Color(0xFFD1D5DB)),
                            SizedBox(height: 16),
                            Text('Aucun avis pour ce produit',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF6B7280),
                              )),
                            SizedBox(height: 6),
                            Text('Soyez le premier à laisser un avis',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF9CA3AF),
                              )),
                          ],
                        ),
                      ),
                    ),
                  )
                else ...[
                  // ── Résumé note moyenne ───────────────────────
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _Ratingsummary(avisList: snapshot.data!),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 16)),

                  // ── Titre section ──────────────────────────────
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          const Text('Tous les avis',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1A1A2E),
                            )),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEEEDFF),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${snapshot.data!.length}',
                              style: const TextStyle(
                                color: Color(0xFF6C63FF),
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 12)),

                  // ── Liste avis ─────────────────────────────────
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => _AvisCard(avis: snapshot.data![index]),
                        childCount: snapshot.data!.length,
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

// ── Widget résumé note moyenne ────────────────────────────────────────────────
class _Ratingsummary extends StatelessWidget {
  final List<Avis> avisList;
  const _Ratingsummary({required this.avisList});

  @override
  Widget build(BuildContext context) {
    final moyenne = avisList.map((a) => a.note).reduce((a, b) => a + b) /
        avisList.length;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C63FF).withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            children: [
              Text(moyenne.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E),
                  height: 1,
                )),
              const SizedBox(height: 6),
              Row(
                children: List.generate(5, (i) => Icon(
                  i < moyenne.round() ? Icons.star_rounded : Icons.star_outline_rounded,
                  color: const Color(0xFFFFB347),
                  size: 16,
                )),
              ),
              const SizedBox(height: 4),
              Text('${avisList.length} avis',
                style: const TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 12,
                )),
            ],
          ),
          const SizedBox(width: 20),
          const VerticalDivider(width: 1, color: Color(0xFFF3F4F6)),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              children: List.generate(5, (i) {
                final note = 5 - i;
                final count = avisList.where((a) => a.note == note).length;
                final ratio = avisList.isEmpty ? 0.0 : count / avisList.length;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Text('$note',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF6B7280),
                          fontWeight: FontWeight.w600,
                        )),
                      const SizedBox(width: 6),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: ratio,
                            minHeight: 6,
                            backgroundColor: const Color(0xFFF3F4F6),
                            valueColor: const AlwaysStoppedAnimation(
                              Color(0xFFFFB347)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text('$count',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF6B7280),
                        )),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Card avis individuel ──────────────────────────────────────────────────────
class _AvisCard extends StatelessWidget {
  final Avis avis;
  const _AvisCard({required this.avis});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Avatar initiale
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFEEEDFF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    avis.auteur.isNotEmpty
                        ? avis.auteur[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      color: Color(0xFF6C63FF),
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(avis.auteur,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: Color(0xFF1A1A2E),
                      )),
                    const SizedBox(height: 3),
                    Row(
                      children: List.generate(5, (i) => Icon(
                        i < avis.note
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        color: const Color(0xFFFFB347),
                        size: 14,
                      )),
                    ),
                  ],
                ),
              ),
              // Badge note
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: avis.note >= 4
                      ? const Color(0xFFE6F9F4)
                      : avis.note == 3
                          ? const Color(0xFFFFF4E6)
                          : const Color(0xFFFFEDF1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('${avis.note}/5',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: avis.note >= 4
                        ? const Color(0xFF43C59E)
                        : avis.note == 3
                            ? const Color(0xFFFFB347)
                            : const Color(0xFFFF6584),
                  )),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(avis.commentaire,
            style: const TextStyle(
              color: Color(0xFF4B5563),
              fontSize: 14,
              height: 1.5,
            )),
        ],
      ),
    );
  }
}
