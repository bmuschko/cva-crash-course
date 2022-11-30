# Exercise 6

In this exercise, you will create a service and a batch token. Moreover, you will use other operations for token, e.g. renewal and revocation.

1. Log in with the root token.
2. Create a service token that uses the `default` policy and defines a TTL of 24 hours.
3. Look up the details of the new token by ID and accessor.
4. Revoke the token using the accessor.
5. Create a batch token that uses the `default` policy and defines a TTL of 60 minutes.
6. Look up the details of the new token by ID. Can you look up token details by accessor?
7. Renew the batch token. What's the result?