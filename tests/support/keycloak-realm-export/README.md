# Keycloak realm export anonymizer

1. Export realm settings from keycloak, you'll get a file called `realm-export.json`.
2. Install dependencies for this package: `npm ci`
3. Clean the exported file: `node src/index.mjs $downloadedExportJSON > realm-export.json
