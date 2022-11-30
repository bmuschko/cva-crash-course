# Exercise 5

In this exercise, you will assign the policy to a user created with the Userpass authentication method. Logged in as the user, you will make a call to the API path we allowed it to call.

> **_NOTE:_** You can find more information about the `sys/mounts` endpoint in the [API documentation](https://developer.hashicorp.com/vault/api-docs/system/mounts).

1. Log in with the root token.
2. Enable the Userpass authentication method and create a user `jill`. Assign the password `123`.
3. Log in with the user `jill`.
4. Make an API call to the endpoint `sys/mounts`. What's the response you see?
5. Log in with the root token.
6. Assign the policy `mounts-list` created in the last exercise to the user `jill`.
7. Log in with the user `jill`.
8. Make an API call to the endpoint `sys/mounts`. Does the API call succeed?
9. Delete the policy `mounts-list`.
10. Make another API call to the endpoint `sys/mounts`. The call should fail.