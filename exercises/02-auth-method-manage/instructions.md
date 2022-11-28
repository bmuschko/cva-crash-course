# Exercise 2

In this exercise, you will two authentication methods, an Userpass, and an AppRole. Feel free to use the CLI or the UI to achieve the goal.

1. Log into Vault with the root token.
2. List the existing authentication methods. Which authentication method should you see listed?
3. Enable an Userpass authentication method. Do not specify any custom configuration.
4. Enable an AppRole authentication method on the path `global` with a max lease TTL of 30 mins.
5. List the existing authentication methods. Identify the authentication methods you created.
6. Tune the Userpass and AppRole authentication method you created. Provide a description for both. You can pick any description you'd like.
7. Create the user `johndoe` with the password `pwd` for the Userpass authentication method.
8. Create the AppRole `servicebot`. Provide the role name `ci`.