# PostgreSQL upgrade procedure

Recommendation: test any DB upgrade on a testing server like `underground`.
Make sure to check software compatibility with the new DB version.

### Summary of steps to upgrade

1. Prepare an update script like `hosts/nachtigall/upgrade-postgresql.nix`.
   Ensure that all systemd services that rely on postgresql are stopped, they
   might immediately restart postgresql after stopping it otherwise.
2. [Deploy](./deploying.md) the script to `nachtigall` using deploy-rs
3. Review the final script with: cat $(which upgrade-pg-cluster)
4. Run the script: `upgrade-pg-cluster`
5. In the nix `postgresql` module options, set the package version to the new
   version, e.g. `services.postgresql.package = pkgs.postgresql_18;`
6. [Deploy](./deploying.md) the new postgresql version using deploy-rs. This
   will also restart all stopped systemd services

Example upgrade:

- https://git.pub.solar/pub-solar/infra/issues/493
- https://git.pub.solar/pub-solar/infra/pulls/496

Duration of upgrade from version 14 to 18 on 2026-01-14 with database stopped:
ca. 10 minutes.

Links:

- https://nixos.org/manual/nixos/unstable/#module-services-postgres-upgrading
