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

Create a child token using the root token. The assigned policies can be specified with the `-policy` option, time-to-live can be defined using the `-ttl` option.

```
$ vault token create -policy=default -ttl=24h
Key                  Value
---                  -----
token                hvs.CAESIAmmsG7F20HTbztkJyrjPOxXgyZYW_NRtnx4h4imXRXQGh4KHGh2cy5ndmlocjJYaHNRejdIcGFpOTVteVV0U2Q
token_accessor       pTMjI5kDqmFazJOCCoQTNgdb
token_duration       24h
token_renewable      true
token_policies       ["default"]
identity_policies    []
policies             ["default"]
```

You can look up the details of the newly-created token. You will find that the TTL started to count down based on the specified max TTL. The type of the token is `service`.

```
$ vault token lookup hvs.CAESIAmmsG7F20HTbztkJyrjPOxXgyZYW_NRtnx4h4imXRXQGh4KHGh2cy5ndmlocjJYaHNRejdIcGFpOTVteVV0U2Q
Key                 Value
---                 -----
accessor            pTMjI5kDqmFazJOCCoQTNgdb
creation_time       1669824999
creation_ttl        24h
display_name        token
entity_id           n/a
expire_time         2022-12-01T09:16:39.722267-07:00
explicit_max_ttl    0s
id                  hvs.CAESIAmmsG7F20HTbztkJyrjPOxXgyZYW_NRtnx4h4imXRXQGh4KHGh2cy5ndmlocjJYaHNRejdIcGFpOTVteVV0U2Q
issue_time          2022-11-30T09:16:39.72227-07:00
meta                <nil>
num_uses            0
orphan              false
path                auth/token/create
policies            [default]
renewable           true
ttl                 23h57m55s
type                service
```

Similar information can be retrieved using the accessor. In this case, the accessor is `pTMjI5kDqmFazJOCCoQTNgdb`. Note that the ID does not get rendered.

```
$ vault token lookup -accessor pTMjI5kDqmFazJOCCoQTNgdb
Key                 Value
---                 -----
accessor            pTMjI5kDqmFazJOCCoQTNgdb
creation_time       1669824999
creation_ttl        24h
display_name        token
entity_id           n/a
expire_time         2022-12-01T09:16:39.722267-07:00
explicit_max_ttl    0s
id                  n/a
issue_time          2022-11-30T09:16:39.72227-07:00
meta                <nil>
num_uses            0
orphan              false
path                auth/token/create
policies            [default]
renewable           true
ttl                 23h56m9s
type                service
```

Revoke the token using the accessor.

```
$ vault token revoke -accessor pTMjI5kDqmFazJOCCoQTNgdb
Success! Revoked token (if it existed)
```

Create a batch token by specifying the type `batch`. You can see in the output that a batch token does not provide an accessor.

```
$ vault token create -type=batch -policy=default -ttl=60m
Key                  Value
---                  -----
token                hvb.AAAAAQIsoyQpX8TS2KiDv2CSpapgRihMKbT1HboYLsTRNojmO-Qak4aRrzMeeTgoDo8rBsAVxOaXcO-wZCmArlgyDzne6B0ZJ4b6rfxOtJgwkk-rkUswqcb8eOOBjmsRRtlSXKSRcbnWJrOzQB029vtOwi9SLZis2g
token_accessor       n/a
token_duration       1h
token_renewable      false
token_policies       ["default"]
identity_policies    []
policies             ["default"]
```

Looking up the token will expose its type.

```
$ vault token lookup hvb.AAAAAQIsoyQpX8TS2KiDv2CSpapgRihMKbT1HboYLsTRNojmO-Qak4aRrzMeeTgoDo8rBsAVxOaXcO-wZCmArlgyDzne6B0ZJ4b6rfxOtJgwkk-rkUswqcb8eOOBjmsRRtlSXKSRcbnWJrOzQB029vtOwi9SLZis2g
Key                 Value
---                 -----
accessor            n/a
creation_time       1669826890
creation_ttl        1h
display_name        token
entity_id           n/a
expire_time         2022-11-30T10:48:10-07:00
explicit_max_ttl    0s
id                  hvb.AAAAAQIsoyQpX8TS2KiDv2CSpapgRihMKbT1HboYLsTRNojmO-Qak4aRrzMeeTgoDo8rBsAVxOaXcO-wZCmArlgyDzne6B0ZJ4b6rfxOtJgwkk-rkUswqcb8eOOBjmsRRtlSXKSRcbnWJrOzQB029vtOwi9SLZis2g
issue_time          2022-11-30T09:48:10-07:00
meta                <nil>
num_uses            0
orphan              false
path                auth/token/create
policies            [default]
renewable           false
ttl                 57m43s
type                batch
```

Trying to review a batch token will not allow the operation.

```
$ vault token renew hvb.AAAAAQIsoyQpX8TS2KiDv2CSpapgRihMKbT1HboYLsTRNojmO-Qak4aRrzMeeTgoDo8rBsAVxOaXcO-wZCmArlgyDzne6B0ZJ4b6rfxOtJgwkk-rkUswqcb8eOOBjmsRRtlSXKSRcbnWJrOzQB029vtOwi9SLZis2g
Error renewing token: Error making API request.

URL: PUT http://127.0.0.1:8200/v1/auth/token/renew
Code: 400. Errors:

* batch tokens cannot be renewed
```