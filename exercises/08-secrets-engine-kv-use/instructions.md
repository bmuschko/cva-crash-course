# Exercise 8

In this exercise, you will interact with a kv secrets engine by adding, updating, and deleting new secrets.

1. Use the `kv` command to create a new secret at the path `app-kv/ext-service`. The secret creates a single key-value pair `api-key=iRJgazGtbjC9pLZCZnTMRtPk`.
2. Use the `kv` command to read the secret at the path `app-kv/ext-service`. Furthermore, try to just get the value of the key `api-key` with a single command.
3. Change the value of the key `api-key` to `new` and verify that the operation has been performed properly by printing out the command again. How many versions of the entries are available?
4. Change the kv secrets engine to version 2. What's the current version of the entry?
5. Use the `kv patch` command to change the value of the `api-key` to `patched`.
6. Render the current key-value pairs at the path `app-kv/ext-service`. Try to run another command to get back to version 1 of the entry.
7. Destroy version 2 of the secret at the path `app-kv/ext-service` permanently. Can you retrieve the version again?
