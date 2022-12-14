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

Enable the AWS secrets engine with the following command.

```
$ vault secrets enable -path=aws aws
Success! Enabled the aws secrets engine at: aws/
```

Provide the AWS access key and secret key. Replace your credentials with the ones assigned by the CLI options `access_key` and `secret_key`.

```
$ vault write aws/config/root access_key=dJhcRgfknWEEbC8jsQJXdFgX secret_key=oyaNMNdmskYUiMDnDW2toYQR
Success! Data written to: aws/config/root
```

Configure a Vault role using the `write` command. Provide the path `aws/roles/foo`.

```
$ vault write aws/roles/foo credential_type=iam_user policy_document=-<<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "ec2:*",
      "Resource": "*"
    }
  ]
}
EOF
Success! Data written to: aws/roles/foo
```

Generate credentials with the `read` command. The output will spell out information about the lease.

```
$ vault read aws/creds/foo
Key                Value
---                -----
lease_id           aws/creds/foo/mnsqFf3duo3VnpJJzopMSx24
lease_duration     768h
lease_renewable    true
access_key         AKIAQOT5DMEZA3QCXJ7O
secret_key         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
security_token     <nil>
```

You will be able to view the credentials in the AWS dashboard under _Access Management > Users_. Every entry will have the prefix `vault-`.

![aws-users](./imgs/aws-users.png)

Change the configuration for AWS leases with the following command.

```
$ vault write aws/config/lease lease=30m lease_max=30m
Success! Data written to: aws/config/lease
```

Every new lease will use this configuration. As you can see in the output below, the `lease_duration` is set to 30m.

```
$ vault read aws/creds/foo
Key                Value
---                -----
lease_id           aws/creds/foo/wWM6zTdIOBwo538bXinUH8hF
lease_duration     30m
lease_renewable    true
access_key         AKIAQOT5DMEZPZYBGSF6
secret_key         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
security_token     <nil>
```

You now have two leases which you can list with the `list` command.

```
$ vault list sys/leases/lookup/aws/creds/foo
Keys
----
XBAkA3DY6qSVuTcbFCwkgdjK
mnsqFf3duo3VnpJJzopMSx24
```

Use the `-prefix` to revoke all leases by path.

```
$ vault lease revoke -prefix aws/creds/foo
All revocation operations queued successfully!
```

All AWS leases have been deleted.

```
$ vault list sys/leases/lookup/aws/creds/foo
No value found at sys/leases/lookup/aws/creds/foo
```