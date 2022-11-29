# Exercise 3

In this exercise, you will use a user and named AppRole to sign in with Vault through the API and UI. You will learn about using those authentication methods to make a call to the API.

1. Sign into Vault with the CLI. Authenticate with the user `johndoe`. This user has been created in the previous exercise.
2. Use the client token of the user to make a `curl` call to the endpoint `$VAULT_ADDR/v1/secret?help=1`.
3. Sign out of the Vault UI.
4. From the CLI, sign back in with the root token.
5. Retrieve the role ID and secret ID for the named AppRole `global`.
6. Generate a token by providing the role ID and secret ID.
7. Use the client token of the AppRole to make a `curl` call to the endpoint `$VAULT_ADDR/v1/secret?help=1`.