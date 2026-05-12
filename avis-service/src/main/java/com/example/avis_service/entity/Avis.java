package com.example.avis_service.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "avis")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Avis {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private Long produitId;

    @Column(nullable = false)
    private String auteur;

    @Column(columnDefinition = "TEXT")
    private String commentaire;

    @Column(nullable = false)
    private int note; // 1 à 5
}