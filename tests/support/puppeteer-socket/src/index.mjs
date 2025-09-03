#!/usr/bin/env node

import http from 'node:http';
import puppeteer from 'puppeteer-core';

const PUPPETEER_SOCKET = '/tmp/puppeteer.sock';
const EXECUTABLE = process.env.EXECUTABLE || 'firefox';

(async () => {
  const browser = await puppeteer.launch({
    executablePath: EXECUTABLE,
    headless: true,
    devtools: false,
    browser: 'chrome',
    protocolTimeout: 600000,
  });

  const page = await browser.newPage();
  await page.setDefaultNavigationTimeout(60000);
  await page.setViewport({
    width: 1200,
    height: 600,
  });

  const server = http.createServer({});
  server.on('request', (req, res) => {
    const chunks = [];
    req.on('data', (chunk) => {
      chunks.push(chunk);
    });

    req.on('end', async () => {
      try {
        const content = chunks.join('');
        const val = await eval(content);
        const responseText = (() => {
          try {
            return val.toString();
          } catch (err) {
            return val;
          }
        })();

        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(responseText);
      } catch (err) {
        console.error(err);
        res.writeHead(500, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ error: err.toString() }));
      }
    });
  });

  server.listen(PUPPETEER_SOCKET, () => {
    console.log('[puppeteer-socket] Listening!');
  });
})();
