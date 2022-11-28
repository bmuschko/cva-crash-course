# Solution

Log in with the root token. You can simply use the environment variables we set in an earlier exercise or provide the plain-text values with the `login` command.

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

Initially, you start out with a single authentication method. That is the root token. You can list the authentication method with the following command.

```
$ vault auth list
Path      Type     Accessor               Description                Version
----      ----     --------               -----------                -------
token/    token    auth_token_4e0f2b43    token based credentials    n/a
```

Enable the Userpass and AppRole authentication methods. The first command uses the default configuration for the Userpass authentication method. Custom configuration, such as the path and max lease TTL, has been provided for the AppRole authentication method.

```
$ vault auth enable userpass
Success! Enabled userpass auth method at: userpass
$ vault auth enable -path=global -max-lease-ttl=30m approle
Success! Enabled approle auth method at: global/
```

The newly-created authentication methods will be listed when running the `auth list` command. At this time, the Userpass and AppRole authentication methods do not render a description.

```
$ vault auth list
Path         Type        Accessor                  Description                Version
----         ----        --------                  -----------                -------
global/      approle     auth_approle_df462445     n/a                        n/a
token/       token       auth_token_4e0f2b43       token based credentials    n/a
userpass/    userpass    auth_userpass_ab2f32b6    n/a                        n/a
```

You can add a description for both authentication methods by tuning them. Refer to the authentication method by path when running the `auth tune` command.

```
$ vault auth tune -description="Username and password" userpass/
Success! Tuned the auth method at: userpass/
$ vault auth tune -description="Role-based credentials" global/
Success! Tuned the auth method at: global/
```

The tuned authentication method now show the provided description.

```
$ vault auth list
Path         Type        Accessor                  Description                Version
----         ----        --------                  -----------                -------
global/      approle     auth_approle_df462445     Role-based credentials     n/a
token/       token       auth_token_4e0f2b43       token based credentials    n/a
userpass/    userpass    auth_userpass_ab2f32b6    Username and password      n/a
```

Use the `write` command and the corresponding path to create a user and a named AppRole.

```
$ vault write auth/userpass/users/johndoe password=pwd
Success! Data written to: auth/userpass/users/johndoe
$ vault write auth/global/role/servicebot role_name="ci"
Success! Data written to: auth/global/role/servicebot
```

To verify the entries, check them by running the `list` command for the corresponding paths.

```
$ vault list auth/userpass/users
Keys
----
johndoe
$ vault list auth/global/role
Keys
----
servicebot
```