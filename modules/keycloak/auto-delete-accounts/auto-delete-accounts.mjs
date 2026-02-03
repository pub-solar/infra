#!/usr/bin/env zx

import { add, sub, isEqual, isAfter } from "date-fns";

const realm = argv.realm;
const clientId = argv.clientId;
const server = argv.server;

/*
 * You'll have to set KC_CLI_CLIENT_SECRET
 */

let users = JSON.parse(await $`kcadm.sh get users -r ${realm} --server ${server} --client ${clientId} --no-config"`);

// Set a last-login value to today for any accounts that do not have one

const noLastLogin = users.filter(user => !user.attributes?.["last-login"]?.length);

const now = new Date();
const todayString = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-${now.getDate()}`;
await Promise.all(noLastLogin.map((user) => {
  const attributes = {
    "last-login": [todayString],
    ...user.attributes,
  };
  $`kcadm.sh update users/${user.id} -s 'attributes=${JSON.stringify(attributes)}' -r ${realm} --server ${server} --client ${clientId} --no-config"`;
}));

users = JSON.parse(await $`kcadm.sh get users -r ${realm} --server ${server} --client ${clientId} --no-config"`);

// Handle non-validated users

const nonValidated = users.filter(user => !user.emailVerified);

await Promise.all(nonValidated.map((user) => {
  const lastLogin = new Date(user.attributes?.["last-login"]);

  const deletionDate = add(lastLogin, { months: 1 });

  if (isEqual(now, sub(deletionDate, { weeks: 1 })) {
    // send reminder
  }

  if (isEqual(now, sub(deletionDate, { days: 1 })) {
    // send reminder
  }

  if (isAfter(now, deletionDate)) {
    // delete
  }
}).filter(n => !!n));

const validated = users.filter(user => user.emailVerified);

await Promise.all(validated.map((user) => {
  const lastLogin = new Date(user.attributes?.["last-login"]);

  const deletionDate = add(lastLogin, { years: 2 });

  if (isEqual(now, sub(deletionDate, { months: 1 })) {
    // Send reminder to validated accounts that have not logged in for 2 years - 1 month
  }

  if (isEqual(now, sub(deletionDate, { weeks: 1 })) {
    // Send reminder to validated accounts that have not logged in for 2 years - 1 week
  }

  if (isEqual(now, sub(deletionDate, { days: 1 })) {
    // Send reminder to validated accounts that have not logged in for 2 years - 1 day
  }

  if (isEqual(now, deletionDate)) {
    // Delete validated that have not logged in for more than 2 years
  }
}).filter(n => !!n));
