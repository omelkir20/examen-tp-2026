package com.example.avis_service.service;

import com.example.avis_service.client.ProduitClient;
import com.example.avis_service.entity.Avis;
import com.example.avis_service.exception.ProduitNotFoundException;
import com.example.avis_service.repository.AvisRepository;
import feign.FeignException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class AvisService {

    private final AvisRepository avisRepository;
    private final ProduitClient produitClient;

    public List<Avis> findByProduitId(Long produitId) {
        return avisRepository.findByProduitId(produitId);
    }

    public Avis save(Avis avis) {
        // Vérifie l'existence du produit via Feign
        try {
            produitClient.findById(avis.getProduitId());
        } catch (FeignException.NotFound e) {
            throw new ProduitNotFoundException(avis.getProduitId());
        }
        return avisRepository.save(avis);
    }
}