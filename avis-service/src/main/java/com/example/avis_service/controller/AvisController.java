package com.example.avis_service.controller;

import com.example.avis_service.entity.Avis;
import com.example.avis_service.service.AvisService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/avis")
@RequiredArgsConstructor
@Tag(name = "Avis", description = "Gestion des avis produits")
public class AvisController {

    private final AvisService avisService;

    @GetMapping("/{produitId}")
    @Operation(summary = "Liste les avis d'un produit")
    public ResponseEntity<List<Avis>> findByProduitId(
            @PathVariable Long produitId) {
        return ResponseEntity.ok(avisService.findByProduitId(produitId));
    }

    @PostMapping
    @Operation(summary = "Soumettre un avis")
    public ResponseEntity<Avis> save(@RequestBody Avis avis) {
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(avisService.save(avis));
    }
}