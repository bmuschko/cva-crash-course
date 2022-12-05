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

List all available secret engines. You will be presented with the default secret engines and any engines you may have created before. The following output shows the default secret engines `cubbyhole`, `identity`, and `sys`. If you are running the Vault development server then you will also see the `secret` kv secrets engine.

```
$ vault secrets list
Path          Type         Accessor              Description
----          ----         --------              -----------
cubbyhole/    cubbyhole    cubbyhole_e03aff1a    per-token private secret storage
identity/     identity     identity_3b6c23eb     identity store
secret/       kv           kv_d0adb6b0           key/value secret storage
sys/          system       system_47c5e1dd       system endpoints used for control, policy and debugging
```

Enable the secrets engine with the following command. The secrets engine became available on path `app-kv/`. The version of the kv engine is 1. With the current version of Vault, not providing a `-version` option will fall back to version 1.

```
$ vault secrets enable -path=app-kv -version=1 kv
Success! Enabled the kv secrets engine at: app-kv/
```

Checking the list of enabled secrets engines will now render the freshly-enabled kv engine.

```
$ vault secrets list
Path          Type         Accessor              Description
----          ----         --------              -----------
app-kv/       kv           kv_de1bd426           n/a
cubbyhole/    cubbyhole    cubbyhole_e03aff1a    per-token private secret storage
identity/     identity     identity_3b6c23eb     identity store
secret/       kv           kv_d0adb6b0           key/value secret storage
sys/          system       system_47c5e1dd       system endpoints used for control, policy and debugging
```

You can read the tunable attributes using the `read` command and pointing to the path.

```
$ vault read sys/mounts/app-kv/tune
Key                  Value
---                  -----
default_lease_ttl    768h
description          n/a
force_no_cache       false
max_lease_ttl        768h
options              map[version:1]
```

Tune the attributes using the `secrets tune` command. See the [documentation](https://developer.hashicorp.com/vault/docs/commands/secrets/tune) for a full list of options.

```
$ vault secrets tune -description="Application kv secrets engine" -max-lease-ttl="120h" app-kv
Success! Tuned the secrets engine at: app-kv/
```

To verify the change of configuration, re-read the attributes of the kv secrets engine.

```
$ vault read sys/mounts/app-kv/tune
Key                  Value
---                  -----
default_lease_ttl    768h
description          Application kv secrets engine
force_no_cache       false
max_lease_ttl        120h
options              map[version:1]
```