{
  axeman = rec {
    sshPubKeys = {
      axeman-1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMNeQYLFauAbzDyIbKC86NUh9yZfiyBm/BtIdkcpZnSU axeman@tuxnix";
    };

    secretEncryptionKeys = sshPubKeys;

    wireguardDevices = [
      {
        # tuxnix
        publicKey = "fTvULvdsc92binFaBV+uWwFi33bi8InShcaPnoxUZEA=";
        allowedIPs = [
          "10.7.6.203/32"
          "fd00:fae:fae:fae:fae:203::/96"
        ];
      }
    ];
  };

  b12f = rec {
    sshPubKeys = {
      b12f-gpg = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDVbUEOgciblRPOCaCkkwfYoKLjmJ6JKxnfg6MY7sN3W1/N4AsC27bvYPkYI66d4M3Ygi6nztaUrIIKBOPZrQtS0vx1jqosmcDwBMttNI7u4LdSDjGMEGB4zJdfR60HFuzpSNaBI/nKMWcAxr8v1KODy/mKTQ7fnMDN15OhvE7sAZe26B6IptUbG1DLuouezd4AW0OwQ3c6hVIuv5eF96OKrwFZ9XpNyYAashy8WTYqJWJRb71DV8oiqT9b3sN0Dy+7nUAPcLvJdwUDGjHQvnklgFUupKtrPhpRWqgJ41l4ebb1DCxmoL2zpdVohUK4eVC9ELdplvXtK+EJIJ1lKcDAYduYcxk//3+EdUDH0IkfXvz0Tomryu2BeyxURdMPzQh+ctHUWNI49tByx/mWrEqSu+XdgvtcumVg+jNUZKL9eA++xxuOan7H/OyshptLugZHd2e9JNM34NEOUEptq7LtHD5pEdXRV1ZT1IOsuSoDtdX14GeP2GSl21eKLnvSu9g8nGULIsx9hI3CrrlvvL9JU+Aymb4iEvqLhDeUNE643uYQad6P2SuK0kLQ/9Ny0z3y6bgglGn2uDUiAOPd8c+gFRRkMWvAWjWQi3iIR9TYBS4Z+CeYmUv8X2UCRcQPBn1wt69rvE9RcfHqRLZTUE5SpstQ0rXLinXmRA/WQV5Bdw== yubi-gpg";
    };

    secretEncryptionKeys = {
      bbcom = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCmXpOU6vzQiVSSYCoxHYv7wDxC63Qg3dxlAMR6AOzwIABCU5PFFNcO0NWYms/YR7MOViorl+19LCLRABar9JgHU1n+uqxKV6eGph3OPeMp5sN8LAh7C9N+TZj8iJzBxQ3ch+Z/LdmLRwYNJ7KSUI+gwGK6xRS3+z1022Y4P0G0sx7IeCBl4lealQEIIF10ZOfjUdBcLQar7XTc5AxyGKnHCerXHRtccCoadLQujk0AvPXbv3Ma4JwX9X++AnCWRWakqS5UInu2tGuZ/6Hrjd2a9AKWjTaBVDcbYqCvY4XVuMj2/A2bCceFBaoi41apybSk26FSFTU4qiEUNQ6lxeOwG4+1NCXyHe2bGI4VyoxinDYa8vLLzXIRfTRA0qoGfCweXNeWPf0jMqASkUKaSOH5Ot7O5ps34r0j9pWzavDid8QeKJPyhxKuF1a5G4iBEZ0O9vuti60dPSjJPci9oTxbune2/jb7Sa0yO06DtLFJ2ncr5f70s/BDxKk4XIwQLy+KsvzlQEGdY8yA6xv28bOGxL3sQ0HE2pDTsvIbAisVOKzdJeolStL9MM5W8Hg0r/KkGj2bg0TfoRp1xHV9hjKkvJrsQ6okaPvNFeZq0HXzPhWMOVQ+/46z80uaQ1ByRLr3FTwuWJ7F/73ndfxiq6bDE4z2Ji0vOjeWJm6HCxTdGw== hello@benjaminbaedorf.com";
      yubi485 = "age1yubikey1qgxuu2x3uzw7k5pg5sp2dv43edhwdz3xuhj7kjqrnw0p8t0l67c5yz9nm6q";
      yubi464 = "age1yubikey1qd7szmr9ux2znl4x4hzykkwaru60nr4ufu6kdd88sm7657gjz4x5w0jy4y7";
    }
    // sshPubKeys;

    wireguardDevices = [
      {
        # stroopwafel
        publicKey = "NNb7T8Jmn+V2dTZ8T6Fcq7hGomHGDckKoV3kK2oAhSE=";
        allowedIPs = [
          "10.7.6.200/32"
          "fd00:fae:fae:fae:fae:200::/96"
        ];
      }
      {
        # chocolatebar
        publicKey = "AS9w0zDUFLcH6IiF6T1vsyZPWPJ3p5fKsjIsM2AoZz8=";
        allowedIPs = [
          "10.7.6.205/32"
          "fd00:fae:fae:fae:fae:205::/96"
        ];
      }
      {
        # biolimo
        publicKey = "gnLq6KikFVVGxLxPW+3ZnreokEKLDoso+cUepPOZsBA=";
        allowedIPs = [
          "10.7.6.206/32"
          "fd00:fae:fae:fae:fae:206::/96"
        ];
      }
      {
        # droppie
        # WARNING: this host is used for backups!
        # Don't remove without consultation
        publicKey = "5Q5hqjLiPppiKjqENOivCLP4LKlUgHq/GmghvRDF7nQ=";
        allowedIPs = [
          "10.7.6.210/32"
          "fd00:fae:fae:fae:fae:210::/96"
        ];
      }
    ];
  };

  hensoko = rec {
    sshPubKeys = {
      hensoko-1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEbaQdxp7Flz6ttELe63rn+Nt9g43qJOLih6VCMP4gPb";
      hensoko-2 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAqkqMYgncrnczcW/0PY+Z+FmNXXpgw6D9JWTTwiainy";
    };

    secretEncryptionKeys = sshPubKeys;
    wireguardDevices = [
      {
        # judy
        publicKey = "I+gN7v1VXkAGoSir6L8aebtLbguvy5nAx1QVDTzdckk=";
        allowedIPs = [
          "10.7.6.202/32"
          "fd00:fae:fae:fae:fae:202::/96"
        ];
      }
    ];
  };

  realestninja = rec {
    sshPubKeys = {
      realestninja-1 = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC6jbZHpLfMiHJ/xFrIfnxb0aXeeDFys4qHG7Ke5DnFkVt9Su6EajsumSOtu1slQm+mu5/BVOopgCqzEptWlQ29XPY5h0HQxjVRcI3+W+gup1GwLLEbEcBNZxp2l7d9zQXWRe5x7Yz6U7vtNHFGpiRnbEnrSNCurN2q7h3vuurAVdHVU3W9pxX2wJyCvKZIZpvnKOlY4dIWnna9Qf6McPt8C6DuX62BshHVpJgkyDoXYxzNCMnnzByEem2VwCRZ0tT8mMMsECC69cChBp4IWneoy0PkU+qL7YZs/s8FEpjwnXyiZ8tR0E9f19+mv1zGhK5bnPst40VKrsxtvcU+JiSF the@realest.ninja";
      realestninja-2 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILaGwiW1y7PGa4dxkdSuKQmtMmpesYJITSo8pe/dUYr/ 2025";
    };

    secretEncryptionKeys = sshPubKeys;

    wireguardDevices = [
      {
        # X1
        publicKey = "b4zxBYY447uUZyCbpX6Ap7QLkjqJdo9thNyaPVAf2T8=";
        allowedIPs = [
          "10.7.6.208/32"
          "fd00:fae:fae:fae:fae:208::/96"
        ];
      }
    ];
  };

  teutat3s = {
    sshPubKeys = {
      teutat3s-1 = "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBFro/k4Mgqyh8yV/7Zwjc0dv60ZM7bROBU9JNd99P/4co6fxPt1pJiU/pEz2Dax/HODxgcO+jFZfvPEuLMCeAl0= YubiKey #10593996 PIV Slot 9a";
      teutat3s-2 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHcU6KPy4b1MQXd6EJhcYwbJu7E+0IrBZF/IP6T7gbMf teutat3s@dumpyourvms";
      teutat3s-3 = "sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBGDkHv5xNd+n/9UEoMXLfsj7vz6SCZWnVFPlDevO5HqH5HKzEE5h5XUlfWPsR6du6kfZqVrevWs/rCv86XaZQUAAAAALdGVybWl1cy5jb20= teutat3s YubiKey 5 NFC FIDO 2";
      teutat3s-4 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPAsRdVYK0077cdtavmrRr6akrI68T1EDY4Hfv4+W86J teutat3s@ryzensun";
      teutat3s-5 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM2PKRskuNfBNwfpKImQ0mI8ACUfnsDGUsP0P041IFq0 teutat3s@neo";
    };

    secretEncryptionKeys = {
      teutat3s-1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHcU6KPy4b1MQXd6EJhcYwbJu7E+0IrBZF/IP6T7gbMf teutat3s@dumpyourvms";
      teutat3s-2 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPAsRdVYK0077cdtavmrRr6akrI68T1EDY4Hfv4+W86J teutat3s@ryzensun";
      teutat3s-3 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM2PKRskuNfBNwfpKImQ0mI8ACUfnsDGUsP0P041IFq0 teutat3s@neo";
    };

    wireguardDevices = [
      {
        # dumpyourvms
        publicKey = "3UrVLQrwXnPAVXPiTAd7eM3fZYxnFSYgKAGpNMUwnUk=";
        allowedIPs = [
          "10.7.6.201/32"
          "fd00:fae:fae:fae:fae:201::/96"
        ];
      }
      {
        # ryzensun
        publicKey = "oVF2/s7eIxyVjtG0MhKPx5SZ1JllZg+ZFVF2eVYtPGo=";
        allowedIPs = [
          "10.7.6.204/32"
          "fd00:fae:fae:fae:fae:204::/96"
        ];
      }
      {
        # neo
        publicKey = "hh5Hx/TlYMDawfuBcXfJWVlE06xvX5f1gOJfEhsbF1s=";
        allowedIPs = [
          "10.7.6.207/32"
          "fd00:fae:fae:fae:fae:207::/96"
        ];
      }
      {
        # FP6
        publicKey = "Ebol9UzbrXleH1XuC9cwBq6ILIvXsiiVPXDGlPKxMTQ=";
        allowedIPs = [
          "10.7.6.209/32"
          "fd00:fae:fae:fae:fae:209::/96"
        ];
      }
    ];
  };
}
