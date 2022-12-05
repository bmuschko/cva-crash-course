# Exercise 7

In this exercise, you will enable and configure a kv secrets engine.

1. Log in with the root token.
2. List all available secret engines.
3. Enable the kv secrets engine with the path `app-kv` and version 1.
4. List all available secret engines again. You should see the kv secrets engine at the path `app-kv/`.
5. Read the current configuration of the kv secrets engine for the path `sys/mounts/app-kv/tune`.
6. For the kv secrets engine set the description to `Application kv secrets engine`, and the maximum lease TTL to `120h`.