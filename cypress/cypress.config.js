const { defineConfig } = require('cypress');

module.exports = defineConfig({
  e2e: {
    baseUrl: 'http://localhost:8090',
    specPattern: 'cypress/e2e/**/*.cy.js',
  },
});