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
  const actions = [];

  const server = http.createServer({}, (req, res) => {
    const chunks = [];
    req.on('data', (chunk) => {
      console.log(`got data ${chunk}`);
      chunks.push(chunk);
    });

    req.on('end', async () => {
      try {
        const content = chunks.join('');

        console.log(`Executing ${content}`);
        eval(`actions.push(${content})`);

        const val = await actions[actions.length - 1];

        res.writeHead(200, { 'Content-Type': 'application/json' });
        let responseText;
        try {
          responseText = JSON.stringify({ data: val });
        } catch (err) {
          responseText = val.toString();
        }

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
