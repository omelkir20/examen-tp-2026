import 'package:flutter/material.dart';
import '../models/categorie.dart';
import '../services/api_service.dart';
import 'produits_screen.dart';

// Icônes et couleurs par catégorie
const _categoryStyles = {
  'Électronique': {'icon': Icons.devices_rounded,     'color': Color(0xFF6C63FF), 'bg': Color(0xFFEEEDFF)},
  'Vêtements':    {'icon': Icons.checkroom_rounded,   'color': Color(0xFFFF6584), 'bg': Color(0xFFFFEDF1)},
  'Livres':       {'icon': Icons.menu_book_rounded,   'color': Color(0xFF43C59E), 'bg': Color(0xFFE6F9F4)},
  'default':      {'icon': Icons.category_rounded,    'color': Color(0xFFFFB347), 'bg': Color(0xFFFFF4E6)},
};

Map<String, dynamic> _styleFor(String nom) {
  return (_categoryStyles[nom] ?? _categoryStyles['default']!) as Map<String, dynamic>;
}

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final ApiService _api = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      body: SafeArea(
        child: FutureBuilder<List<Categorie>>(
          future: _api.getCategories(),
          builder: (context, snapshot) {
            return CustomScrollView(
              slivers: [
                // ── Header ──────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFF6C63FF),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.storefront_rounded,
                                  color: Colors.white, size: 22),
                            ),
                            const SizedBox(width: 12),
                            const Text('Boutique',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1A1A2E),
                                letterSpacing: -0.5,
                              )),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Text('Catégories',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6B7280),
                          )),
                      ],
                    ),
                  ),
                ),

                // ── État chargement / erreur ─────────────────────
                if (snapshot.connectionState == ConnectionState.waiting)
                  const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF6C63FF),
                        strokeWidth: 2.5,
                      ),
                    ),
                  )
                else if (snapshot.hasError)
                  SliverFillRemaining(
                    child: _ErrorWidget(message: snapshot.error.toString()),
                  )
                else ...[
                  // ── Grille catégories ────────────────────────────
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final cat = snapshot.data![index];
                          return _CategoryCard(categorie: cat);
                        },
                        childCount: snapshot.data!.length,
                      ),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 14,
                        childAspectRatio: 1.15,
                      ),
                    ),
                  ),

                  // ── Bannière promo ───────────────────────────────
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                      child: Container(
                        padding: const EdgeInsets.all(20),
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
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Nouveautés 2026',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                    )),
                                  SizedBox(height: 4),
                                  Text('Découvrez nos derniers produits',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                    )),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white24,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.rocket_launch_rounded,
                                color: Colors.white, size: 28),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final Categorie categorie;
  const _CategoryCard({required this.categorie});

  @override
  Widget build(BuildContext context) {
    final style = _styleFor(categorie.nom);
    final color  = style['color'] as Color;
    final bgColor = style['bg'] as Color;
    final icon   = style['icon'] as IconData;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProduitsScreen(categorie: categorie),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(categorie.nom,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Color(0xFF1A1A2E),
                  )),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text('Voir tout',
                      style: TextStyle(
                        fontSize: 12,
                        color: color,
                        fontWeight: FontWeight.w500,
                      )),
                    Icon(Icons.arrow_forward_rounded, size: 12, color: color),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  final String message;
  const _ErrorWidget({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFFEDF1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.wifi_off_rounded,
                color: Color(0xFFFF6584), size: 48),
            ),
            const SizedBox(height: 20),
            const Text('Connexion impossible',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E),
              )),
            const SizedBox(height: 8),
            Text(message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF6B7280), fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
