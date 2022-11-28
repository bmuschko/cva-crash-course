# Exercise 1

In this exercise, you will install the Vault binary on your machine. Afterward, you will run the command for starting the local development server and interact with it.

1. Install the latest Vault binary on your machine. Choose the most fitting [installation method](https://developer.hashicorp.com/vault/tutorials/getting-started/getting-started-install) based on operating system and personal preference.
2. Run the command `vault version` to determine the version of the executable.
3. Run the command `vault -help` and explore the output.
4. Run the command `vault server -dev` to start the development server.
5. Export the environment variable `VAULT_ADDR` and assign the Vault server address. Export the the environment variable `VAULT_TOKEN` and assign the Vault root token.
6. Open a browser, navigate to the URL for development server, and log in with the root token. Explore the UI.
7. Make a `curl` call to the Vault API endpoint `$VAULT_ADDR/v1/sys/host-info`. Use the root token to authenticate.