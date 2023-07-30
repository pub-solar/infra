{ inputs
, self
, ...
}: {
  perSystem = { config, pkgs, system, ... }:
  let
    terraform = pkgs.terraform;

    tf-infra-dns = inputs.terranix.lib.terranixConfiguration {
      inherit system;
      modules = [ ./dns.nix ];
    };

    tf-infra-nodes = inputs.terranix.lib.terranixConfiguration {
      inherit system;
      modules = [
        ./host.nix
        ./vms.nix
      ];
    };
  in {
    packages = {
      inherit tf-infra-dns tf-infra-nodes;
    };

    apps = {
      apply-dns = {
        type = "app";
        program = toString (pkgs.writers.writeBash "apply" ''
          if [[ -e config.tf.json ]]; then rm -f config.tf.json; fi
          cp ${tf-infra-dns} config.tf.json \
            && ${terraform}/bin/terraform init \
            && ${terraform}/bin/terraform apply
        '');
      };
      apply-nodes = {
        type = "app";
        program = toString (pkgs.writers.writeBash "apply" ''
          if [[ -e config.tf.json ]]; then rm -f config.tf.json; fi
          cp ${tf-infra-nodes} config.tf.json \
            && ${terraform}/bin/terraform init \
            && ${terraform}/bin/terraform apply
        '');
      };
      # nix run ".#destroy"
      destroy-dns = {
        type = "app";
        program = toString (pkgs.writers.writeBash "destroy" ''
          if [[ -e config.tf.json ]]; then rm -f config.tf.json; fi
          cp ${tf-infra-dns} config.tf.json \
            && ${terraform}/bin/terraform init \
            && ${terraform}/bin/terraform destroy
        '');
      };
    };
  };
}
