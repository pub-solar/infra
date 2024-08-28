#!/usr/bin/env node

import { readFile } from 'node:fs/promises';
import { v4 } from 'uuid';

const filePath = process.argv[2];

const newIds = {};
const ID_KEYS = [
  'id',
  'containerId',
  '_id',
];

const renameDomain = (s) => s.replace(/pub.solar/g, 'test.pub.solar');

const cleanClients = (data) => ({
  ...data,
  clients: data.clients.map(c => ({
    ...c,
    authorizationSettings: undefined,
    ...(c.secret ? {
      secret: 'secret',
      attributes: {
        ...c.attributes,
        "client.secret.creation.time": +(new Date()),
      },
    } : {}),
  })),
});

const shouldChangeId = (node, key) => ID_KEYS.find(name => name === key) && typeof node[key] === "string";

const changeIds = (node) => {
  if (!node) {
    return node;
  }

  if (Array.isArray(node)) {
    return node.map(n => changeIds(n));
  }

  if (typeof node === "object") {
    return Object.keys(node).reduce((acc, key) => ({
      ...acc,
      [key]: shouldChangeId(node, key)
        ? (() => {
          const oldId = node[key];
          if (newIds[oldId]) {
            return newIds[oldId];
          }

          newIds[oldId] = v4();
          return newIds[oldId];
        })()
        : changeIds(node[key]),
    }), {});
  }

  return node;
};

const setExtra = (data) => ({
  ...data,
  loginTheme: "pub.solar",
  accountTheme: "pub.solar",
  adminTheme: "pub.solar",
  emailTheme: "pub.solar",
  smtpServer: {
    ...data.smtpServer,
    password: "password",
  },
});

(async () => {
  const fileContents = await readFile(filePath, { encoding: 'utf8' });
  const data = JSON.parse(renameDomain(fileContents));

  const newData = setExtra(changeIds(cleanClients(data)));

  console.log(JSON.stringify(newData, null, 2));
})();
