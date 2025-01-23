#!/usr/bin/env node

import http from 'node:http';
import puppeteer from 'puppeteer-core';

const PUPPETEER_SOCKET = '/tmp/puppeteer.sock';
const EXECUTABLE = process.env.EXECUTABLE || 'firefox';

(async () => {
  const firefoxBrowser = await puppeteer.launch({
    executablePath: EXECUTABLE,
    headless: false,
    devtools: true,
    browser: 'firefox',
    extraPrefsFirefox: {},
  });

  const page = await firefoxBrowser.newPage();
  page.on('request', request => {
    console.log(request.url());
  });

  page.on('response', response => {
    console.log(response.url());
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

        console.log(`Executing ${content}`);
        const val = await eval(content);

        const responseText = (() => {
          try {
            return JSON.stringify({ data: val });
          } catch (err) {
            return JSON.stringify({ data: val.toString() });
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
    console.log('Listening!');
  });
})();
