# Exercise 11

In this exercise, you will use the response wrapping concept for a secret in the kv secrets engine.

1. Log in with the root token.
2. Enable the kv secrets engine.
3. Add the entry `hello=world` to the engine at the path `kv/app`.
4. Create a wrapping token for the secret. Set a TTL of 60 minutes.
5. Unwrap the secret with the wrapping token.
6. Try to unwrap the secret again with the same wrapping token.