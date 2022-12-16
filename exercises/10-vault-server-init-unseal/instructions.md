# Exercise 10

In this exercise, you will start the Vault server with a given HCL configuration file. Once up and running, you will initialize and unseal the Vault.

1. Create the configuration file named `vault-server-config.hcl`. The TCP listener should point to `127.0.0.1:8200`. TLS should be disabled. Define a filesystem storage handler pointing to the directory `./vault/data`. The UI needs to become accessible.
2. Start the Vault server with the configuration file.
3. Initialize the Vault so that three unseal keys are created. Only two of those unseal keys should be required to unseal it.
4. Unseal the Vault.
5. Open the server URL in the browser.
6. Log in with the root token.