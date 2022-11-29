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

Enable the Userpass authentication methods and add the user named `jill`.

```
$ vault auth enable userpass
Success! Enabled userpass auth method at: userpass/
$ vault write auth/userpass/users/jill password=123
Success! Data written to: auth/userpass/users/jill
```

Log in with the user `jill`.

```
$ vault login -method=userpass username=jill
Password (will be hidden):
WARNING! The VAULT_TOKEN environment variable is set! The value of this
variable will take precedence; if this is unwanted please unset VAULT_TOKEN or
update its value accordingly.

Success! You are now authenticated. The token information displayed below
is already stored in the token helper. You do NOT need to run "vault login"
again. Future Vault requests will automatically use this token.

Key                    Value
---                    -----
token                  hvs.CAESIDkislQE4FQ_WAvfEMAB3NjmGNmYo4MmyJw1IJ-b1ZjkGh4KHGh2cy5sNmU3SE5KN20wMzdwbDh0aU90eUp3a0g
token_accessor         7vsdQFhfc3Ol0aGZbbzcjZl8
token_duration         768h
token_renewable        true
token_policies         ["default"]
identity_policies      []
policies               ["default"]
token_meta_username    jill
```

Make an API call to the endpoint `sys/mounts`. This user does not have the read permissions for this endpoint.

```
$ curl -H "X-Vault-Token: hvs.CAESIDkislQE4FQ_WAvfEMAB3NjmGNmYo4MmyJw1IJ-b1ZjkGh4KHGh2cy5sNmU3SE5KN20wMzdwbDh0aU90eUp3a0g" $VAULT_ADDR/v1/sys/mounts
{"errors":["1 error occurred:\n\t* permission denied\n\n"]}
```

Switch back to the using the root token.

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

Assign the policy to the user.

```
$ vault write auth/userpass/users/jill token_policies="mounts-list"
Success! Data written to: auth/userpass/users/jill
```

When logging back in with the user `jill`, you will see that the list of policies now contains `mounts-list`.

```
$ vault login -method=userpass username=jill
Password (will be hidden):
WARNING! The VAULT_TOKEN environment variable is set! The value of this
variable will take precedence; if this is unwanted please unset VAULT_TOKEN or
update its value accordingly.

Success! You are now authenticated. The token information displayed below
is already stored in the token helper. You do NOT need to run "vault login"
again. Future Vault requests will automatically use this token.

Key                    Value
---                    -----
token                  hvs.CAESIMaHUkthWF-6oG-6TgeINxojiU_VhOGUn8uaHY0SiOZgGh4KHGh2cy55alhIZmFYNGFUOWFKdEl3VWtOSUs2OEU
token_accessor         w40weSfaqcxtqQ94TvX2oL7i
token_duration         768h
token_renewable        true
token_policies         ["default" "mounts-list"]
identity_policies      []
policies               ["default" "mounts-list"]
token_meta_username    jill
```

Make an API call to the endpoint `sys/mounts`. The user is now allowed to run the operation.

```
$ curl -H "X-Vault-Token: hvs.CAESIMaHUkthWF-6oG-6TgeINxojiU_VhOGUn8uaHY0SiOZgGh4KHGh2cy55alhIZmFYNGFUOWFKdEl3VWtOSUs2OEU" $VAULT_ADDR/v1/sys/mounts
```