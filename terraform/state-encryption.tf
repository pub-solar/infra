# https://opentofu.org/docs/language/state/encryption/#new-project
# Set env var TF_VAR_state_passphrase
variable "state_passphrase" {
  type = string
}

terraform {
  encryption {
    ## Step 1: Add the desired key provider:
    key_provider "pbkdf2" "pub_solar_key" {
      passphrase = var.state_passphrase
    }
    ## Step 2: Set up your encryption method:
    method "aes_gcm" "pub_solar_method" {
      keys = key_provider.pbkdf2.pub_solar_key
    }

    state {
      ## Step 3: Link the desired encryption method:
      method = method.aes_gcm.pub_solar_method

      ## Step 4: Run "tofu apply".

      ## Step 5: Consider adding the "enforced" option:
      # enforced = true
    }

    ## Step 6: Repeat steps 3-5 for plan{} if needed.
  }
}
