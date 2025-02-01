# Matrix account suspension

> Unlike [account locking](https://spec.matrix.org/v1.12/client-server-api/#account-locking),
> [suspension](https://github.com/matrix-org/matrix-spec-proposals/blob/main/proposals/3823-code-for-account-suspension.md)
> allows the user to have a (largely) readonly view of their account.
> Homeserver administrators and moderators may use this functionality to
> temporarily deactivate an account, or place conditions on the account's
> experience. Critically, like locking, account suspension is reversible, unlike
> the deactivation mechanism currently available in Matrix - a destructive,
> irreversible, action.

Required:

- `matrix-synapse admin token`
- [SSH access to host `nachtigall`](./administrative-access.md#ssh-access)

## Suspending an account

```bash
curl --header "Authorization: Bearer <admin-access-token>" --request PUT http://127.0.0.1:8008/_synapse/admin/v1/suspend/@<username>:pub.solar --data '{"suspend": true}'
```

## Unsuspending an account

```bash
curl --header "Authorization: Bearer <admin-access-token>" --request PUT http://127.0.0.1:8008/_synapse/admin/v1/suspend/@<username>:pub.solar --data '{"suspend": false}'
```
