package com.example.avis_service.client;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import java.util.Map;

@FeignClient(name = "produits-service")
public interface ProduitClient {

    @GetMapping("/api/produits/{id}")
    Map<String, Object> findById(@PathVariable("id") Long id);
}