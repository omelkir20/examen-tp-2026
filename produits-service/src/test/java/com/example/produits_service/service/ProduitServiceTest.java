package com.example.produits_service.service;

import com.example.produits_service.entity.Produit;
import com.example.produits_service.repository.ProduitRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ProduitServiceTest {

    @Mock
    private ProduitRepository produitRepository;

    @InjectMocks
    private ProduitService produitService;

    @Test
    void findAll_returnsAllProducts() {
        Produit p1 = Produit.builder().id(1L).nom("Phone").prix(500.0).stock(10).build();
        Produit p2 = Produit.builder().id(2L).nom("Laptop").prix(1000.0).stock(5).build();
        when(produitRepository.findAll()).thenReturn(List.of(p1, p2));

        List<Produit> result = produitService.findAll();

        assertThat(result).hasSize(2);
        assertThat(result.get(0).getNom()).isEqualTo("Phone");
        verify(produitRepository, times(1)).findAll();
    }

    @Test
    void findById_existingId_returnsProduit() {
        Produit p = Produit.builder().id(1L).nom("Phone").prix(500.0).stock(10).build();
        when(produitRepository.findById(1L)).thenReturn(Optional.of(p));

        Produit result = produitService.findById(1L);

        assertThat(result.getNom()).isEqualTo("Phone");
    }

    @Test
    void findById_notFound_throwsException() {
        when(produitRepository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> produitService.findById(99L))
                .isInstanceOf(RuntimeException.class)
                .hasMessageContaining("99");
    }

    @Test
    void save_callsRepository() {
        Produit p = Produit.builder().nom("Nouveau").prix(99.0).stock(20).build();
        when(produitRepository.save(p)).thenReturn(p);

        Produit result = produitService.save(p);

        assertThat(result.getNom()).isEqualTo("Nouveau");
        verify(produitRepository).save(p);
    }
}