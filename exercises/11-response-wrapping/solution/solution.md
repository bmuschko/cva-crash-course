# Solution

Run the `login` command with the root token to sign in.

```
$ vault login -address=$VAULT_ADDR $VAULT_TOKEN
WARNING! The VAULT_TOKEN environment variable is set! The value of this
variable will take precedence; if this is unwanted please unset VAULT_TOKEN or
update its value accordingly.

Success! You are now authenticated. The token information displayed below
is already stored in the token helper. You do NOT need to run "vault login"
again. Future Vault requests will automatically use this token.

Key                  Value
---                  -----
token                hvs.1dx0yCjCNZFQQOfUljLyRukq
token_accessor       6UqLKI9h3mCIWZrUkRFj2s2Z
token_duration       ∞
token_renewable      false
token_policies       ["root"]
identity_policies    []
policies             ["root"]
```

Enable the secrets engine with the following command. The secrets engine became available on path `kv/`.

```
$ vault secrets enable kv
Success! Enabled the kv secrets engine at: kv/
```

Create a new secret using the `kv put` command.

```
$ vault kv put kv/app hello=world
Success! Data written to: kv/app
```

Wrap the kv secret with the following command.

```
$ vault kv get -wrap-ttl=60m kv/app
Key                              Value
---                              -----
wrapping_token:                  hvs.CAESILn8XOKS-lZ-UtiedlzqqrdxcxST09expCnJyVj09-91Gh4KHGh2cy4yTXJuQ2JjdTBRdW55a2I2VGdRTU1IdnI
wrapping_accessor:               GHJj6kC5MVFNRclw7uB1OoVn
wrapping_token_ttl:              1h
wrapping_token_creation_time:    2022-12-16 12:08:22.72283 -0700 MST
wrapping_token_creation_path:    kv/app
```

Use the wrapping token to unwrap the kv secret. You will see the plain-text value of the secret.

```
$ vault unwrap hvs.CAESILn8XOKS-lZ-UtiedlzqqrdxcxST09expCnJyVj09-91Gh4KHGh2cy4yTXJuQ2JjdTBRdW55a2I2VGdRTU1IdnI
Key                 Value
---                 -----
refresh_interval    768h
hello               world
```

Trying to run the `unwrap` command will result in an error. The wrapping token can only be used once.

```
$ vault unwrap hvs.CAESILn8XOKS-lZ-UtiedlzqqrdxcxST09expCnJyVj09-91Gh4KHGh2cy4yTXJuQ2JjdTBRdW55a2I2VGdRTU1IdnI
Error unwrapping: Error making API request.

URL: PUT http://127.0.0.1:8200/v1/sys/wrapping/unwrap
Code: 400. Errors:

* wrapping token is not valid or does not exist
```