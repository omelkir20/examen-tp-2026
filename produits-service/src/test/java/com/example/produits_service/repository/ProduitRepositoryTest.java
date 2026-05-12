package com.example.produits_service.repository;

import com.example.produits_service.entity.Categorie;
import com.example.produits_service.entity.Produit;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.test.context.ActiveProfiles;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@DataJpaTest
@ActiveProfiles("test")
class ProduitRepositoryTest {

    @Autowired
    private ProduitRepository produitRepository;

    @Autowired
    private CategorieRepository categorieRepository;

    @Test
    void findByCategorieId_returnsProduits() {
        Categorie cat = categorieRepository.save(
                Categorie.builder().nom("Tech").build());

        produitRepository.save(Produit.builder()
                .nom("Phone").prix(500.0).stock(10).categorie(cat).build());
        produitRepository.save(Produit.builder()
                .nom("Tablet").prix(300.0).stock(5).categorie(cat).build());

        List<Produit> result = produitRepository.findByCategorieId(cat.getId());

        assertThat(result).hasSize(2);
        assertThat(result).extracting("nom")
                .containsExactlyInAnyOrder("Phone", "Tablet");
    }

    @Test
    void save_persistsProduct() {
        Categorie cat = categorieRepository.save(
                Categorie.builder().nom("Sport").build());

        Produit p = produitRepository.save(Produit.builder()
                .nom("Vélo").prix(450.0).stock(15).categorie(cat).build());

        assertThat(p.getId()).isNotNull();
        assertThat(produitRepository.findById(p.getId())).isPresent();
    }
}