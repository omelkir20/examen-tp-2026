package com.example.produits_service.controller;

import com.example.produits_service.entity.Produit;
import com.example.produits_service.service.ProduitService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/produits")
@RequiredArgsConstructor
@Tag(name = "Produits", description = "Gestion des produits")
public class ProduitController {

    private final ProduitService produitService;

    @GetMapping
    @Operation(summary = "Liste tous les produits ou par catégorie")
    public ResponseEntity<List<Produit>> findAll(
            @RequestParam(required = false) Long categorieId) {
        if (categorieId != null) {
            return ResponseEntity.ok(produitService.findByCategorieId(categorieId));
        }
        return ResponseEntity.ok(produitService.findAll());
    }

    @GetMapping("/{id}")
    @Operation(summary = "Détail d'un produit")
    public ResponseEntity<Produit> findById(@PathVariable Long id) {
        return ResponseEntity.ok(produitService.findById(id));
    }

    @PostMapping
    @Operation(summary = "Créer un produit")
    public ResponseEntity<Produit> save(@RequestBody Produit produit) {
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(produitService.save(produit));
    }
}