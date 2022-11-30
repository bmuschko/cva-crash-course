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

Make an API call to the endpoint `sys/mounts`. The endpoint lists all the mounted secrets engines. The user `jill` does not have the read permissions for this endpoint.

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
{"sys/":{"accessor":"system_47c5e1dd","config":{"default_lease_ttl":0,"force_no_cache":false,"max_lease_ttl":0,"passthrough_request_headers":["Accept"]},"description":"system endpoints used for control, policy and debugging","external_entropy_access":false,"local":false,"options":null,"plugin_version":"","running_plugin_version":"v1.12.1+builtin.vault","running_sha256":"","seal_wrap":true,"type":"system","uuid":"2b70709f-b1d5-c0c1-a9cb-86caf7c12720"},"identity/":{"accessor":"identity_3b6c23eb","config":{"default_lease_ttl":0,"force_no_cache":false,"max_lease_ttl":0,"passthrough_request_headers":["Authorization"]},"description":"identity store","external_entropy_access":false,"local":false,"options":null,"plugin_version":"","running_plugin_version":"v1.12.1+builtin.vault","running_sha256":"","seal_wrap":false,"type":"identity","uuid":"9936e20d-7ef5-32dd-7dc7-41127e06b7c8"},"cubbyhole/":{"accessor":"cubbyhole_e03aff1a","config":{"default_lease_ttl":0,"force_no_cache":false,"max_lease_ttl":0},"description":"per-token private secret storage","external_entropy_access":false,"local":true,"options":null,"plugin_version":"","running_plugin_version":"v1.12.1+builtin.vault","running_sha256":"","seal_wrap":false,"type":"cubbyhole","uuid":"3362a1bd-15e6-e683-6428-b9678b8a46f8"},"secret/":{"accessor":"kv_d0adb6b0","config":{"default_lease_ttl":0,"force_no_cache":false,"max_lease_ttl":0},"deprecation_status":"supported","description":"key/value secret storage","external_entropy_access":false,"local":false,"options":{"version":"2"},"plugin_version":"","running_plugin_version":"v0.13.0+builtin","running_sha256":"","seal_wrap":false,"type":"kv","uuid":"9cf3e8fc-ca46-deff-0384-d2ef08d5b88b"},"request_id":"d73a81a9-58cd-b7fa-62e6-9e0a0cb05361","lease_id":"","renewable":false,"lease_duration":0,"data":{"cubbyhole/":{"accessor":"cubbyhole_e03aff1a","config":{"default_lease_ttl":0,"force_no_cache":false,"max_lease_ttl":0},"description":"per-token private secret storage","external_entropy_access":false,"local":true,"options":null,"plugin_version":"","running_plugin_version":"v1.12.1+builtin.vault","running_sha256":"","seal_wrap":false,"type":"cubbyhole","uuid":"3362a1bd-15e6-e683-6428-b9678b8a46f8"},"identity/":{"accessor":"identity_3b6c23eb","config":{"default_lease_ttl":0,"force_no_cache":false,"max_lease_ttl":0,"passthrough_request_headers":["Authorization"]},"description":"identity store","external_entropy_access":false,"local":false,"options":null,"plugin_version":"","running_plugin_version":"v1.12.1+builtin.vault","running_sha256":"","seal_wrap":false,"type":"identity","uuid":"9936e20d-7ef5-32dd-7dc7-41127e06b7c8"},"secret/":{"accessor":"kv_d0adb6b0","config":{"default_lease_ttl":0,"force_no_cache":false,"max_lease_ttl":0},"deprecation_status":"supported","description":"key/value secret storage","external_entropy_access":false,"local":false,"options":{"version":"2"},"plugin_version":"","running_plugin_version":"v0.13.0+builtin","running_sha256":"","seal_wrap":false,"type":"kv","uuid":"9cf3e8fc-ca46-deff-0384-d2ef08d5b88b"},"sys/":{"accessor":"system_47c5e1dd","config":{"default_lease_ttl":0,"force_no_cache":false,"max_lease_ttl":0,"passthrough_request_headers":["Accept"]},"description":"system endpoints used for control, policy and debugging","external_entropy_access":false,"local":false,"options":null,"plugin_version":"","running_plugin_version":"v1.12.1+builtin.vault","running_sha256":"","seal_wrap":true,"type":"system","uuid":"2b70709f-b1d5-c0c1-a9cb-86caf7c12720"}},"wrap_info":null,"warnings":null,"auth":null}
```

Individual secret engines can be queried for by path. The following path is `secret`.

```
$ curl -H "X-Vault-Token: hvs.CAESIMaHUkthWF-6oG-6TgeINxojiU_VhOGUn8uaHY0SiOZgGh4KHGh2cy55alhIZmFYNGFUOWFKdEl3VWtOSUs2OEU" $VAULT_ADDR/v1/sys/mounts/secret
{"running_sha256":"","type":"kv","description":"key/value secret storage","local":false,"seal_wrap":false,"external_entropy_access":false,"options":{"version":"2"},"running_plugin_version":"v0.13.0+builtin","config":{"default_lease_ttl":0,"force_no_cache":false,"max_lease_ttl":0},"accessor":"kv_d0adb6b0","uuid":"9cf3e8fc-ca46-deff-0384-d2ef08d5b88b","plugin_version":"","deprecation_status":"supported","request_id":"cedb69a2-aaef-00a9-4d68-08edc57999d2","lease_id":"","renewable":false,"lease_duration":0,"data":{"accessor":"kv_d0adb6b0","config":{"default_lease_ttl":0,"force_no_cache":false,"max_lease_ttl":0},"deprecation_status":"supported","description":"key/value secret storage","external_entropy_access":false,"local":false,"options":{"version":"2"},"plugin_version":"","running_plugin_version":"v0.13.0+builtin","running_sha256":"","seal_wrap":false,"type":"kv","uuid":"9cf3e8fc-ca46-deff-0384-d2ef08d5b88b"},"wrap_info":null,"warnings":null,"auth":null}
```

Delete the policy with the `policy delete` command.

```
$ vault policy delete mounts-list
Success! Deleted policy: mounts-list
```

The user cannot access the data anymore.

```
$ curl -H "X-Vault-Token: hvs.CAESIMaHUkthWF-6oG-6TgeINxojiU_VhOGUn8uaHY0SiOZgGh4KHGh2cy55alhIZmFYNGFUOWFKdEl3VWtOSUs2OEU" $VAULT_ADDR/v1/sys/mounts
{"errors":["1 error occurred:\n\t* permission denied\n\n"]}
```