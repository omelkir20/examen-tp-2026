package com.example.avis_service.exception;

public class ProduitNotFoundException extends RuntimeException {
    public ProduitNotFoundException(Long id) {
        super("Produit non trouvé avec l'id : " + id);
    }
}