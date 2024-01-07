# Privacy hardening

Some default options in the services we run are not as privacy friendly as they can be. Oftentimes, services assume they are running for an organization in which everyone knows (or wants to know) everyone else. However, when running a public service accounts should be hidden from other users.

## Nextcloud account leaking

By default, accounts are visible globally across the instance. To prevent this, go into the administration settings -> Sharing. Check the option saying "Restrict users to only share with users in their group".

## Forgejo email leaking

By default, emails are visible on the explore page for other logged in users. We have disabled this in the config by setting `service.DEFAULT_KEEP_EMAIL_PRIVATE` to `true`.
