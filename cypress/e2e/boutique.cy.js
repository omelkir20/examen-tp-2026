describe('Parcours E2E Boutique', () => {
  const API = 'http://localhost:8090';

  it('liste tous les produits', () => {
    cy.request('GET', `${API}/api/produits`).then((response) => {
      expect(response.status).to.eq(200);
      expect(response.body).to.be.an('array');
      expect(response.body.length).to.be.greaterThan(0);
    });
  });

  it('liste les catégories', () => {
    cy.request('GET', `${API}/api/categories`).then((response) => {
      expect(response.status).to.eq(200);
      expect(response.body).to.be.an('array');
      expect(response.body.length).to.be.greaterThan(0);
    });
  });

  it('détail d\'un produit', () => {
    cy.request('GET', `${API}/api/produits/1`).then((response) => {
      expect(response.status).to.eq(200);
      expect(response.body).to.have.property('id', 1);
      expect(response.body).to.have.property('nom');
      expect(response.body).to.have.property('prix');
    });
  });

  it('liste les avis d\'un produit', () => {
    cy.request('GET', `${API}/api/avis/1`).then((response) => {
      expect(response.status).to.eq(200);
      expect(response.body).to.be.an('array');
    });
  });

  it('parcours complet : catégorie → produits → avis', () => {
    // 1. Récupérer les catégories
    cy.request('GET', `${API}/api/categories`).then((catResponse) => {
      expect(catResponse.status).to.eq(200);
      const categorie = catResponse.body[0];

      // 2. Récupérer les produits de cette catégorie
      cy.request('GET', `${API}/api/produits?categorieId=${categorie.id}`)
        .then((prodResponse) => {
          expect(prodResponse.status).to.eq(200);
          const produit = prodResponse.body[0];

          // 3. Récupérer les avis de ce produit
          cy.request('GET', `${API}/api/avis/${produit.id}`)
            .then((avisResponse) => {
              expect(avisResponse.status).to.eq(200);
              expect(avisResponse.body).to.be.an('array');
            });
        });
    });
  });

  it('retourne 404 pour un produit inexistant', () => {
    cy.request({
      method: 'GET',
      url: `${API}/api/produits/9999`,
      failOnStatusCode: false,
    }).then((response) => {
      expect(response.status).to.eq(404);
    });
  });

  it('crée un avis et retourne 404 pour produit inexistant', () => {
    cy.request({
      method: 'POST',
      url: `${API}/api/avis`,
      body: { produitId: 9999, auteur: 'Test', commentaire: 'Test', note: 3 },
      failOnStatusCode: false,
    }).then((response) => {
      expect(response.status).to.eq(404);
    });
  });
});