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

Enable the Transit engine.

```
$ vault secrets enable transit
Success! Enabled the transit secrets engine at: transit/
```

Create the encryption key `chacha` with type `chacha20-poly1305`.

```
$ vault write -f transit/keys/chacha type=chacha20-poly1305
Success! Data written to: transit/keys/chacha
```

Check on the properties of the encryption key.

```
$ vault read transit/keys/chacha
Key                       Value
---                       -----
allow_plaintext_backup    false
auto_rotate_period        0s
deletion_allowed          false
derived                   false
exportable                false
imported_key              false
keys                      map[1:1670984964]
latest_version            1
min_available_version     0
min_decryption_version    1
min_encryption_version    0
name                      chacha
supports_decryption       true
supports_derivation       true
supports_encryption       true
supports_signing          false
type                      chacha20-poly1305
```

Encrypt the value `abc123` with the encryption key. Ensure that you base64-encode the value before sending it to the Transit engine.

```
$ echo "abc123" | base64
YWJjMTIzCg==
$ vault write transit/encrypt/chacha plaintext=YWJjMTIzCg==
Key            Value
---            -----
ciphertext     vault:v1:RWSTpSNEKqGUM3EJEA5cFE7yjf6Bz01F5ih7Tlz3wPYrsVY=
key_version    1
```

Decrypt the value using the ciphertext. Base64-decode the value to see the plain-text representation.

```
$ vault write transit/decrypt/chacha ciphertext=vault:v1:RWSTpSNEKqGUM3EJEA5cFE7yjf6Bz01F5ih7Tlz3wPYrsVY=
Key          Value
---          -----
plaintext    YWJjMTIzCg==
$ echo "YWJjMTIzCg==" | base64 -d
abc123
```

Rotate the encryption key. The `latest_version` key will now show the value 2.

```
$ vault write -f transit/keys/chacha/rotate
Success! Data written to: transit/keys/chacha/rotate
$ vault read transit/keys/chacha
Key                       Value
---                       -----
allow_plaintext_backup    false
auto_rotate_period        0s
deletion_allowed          false
derived                   false
exportable                false
imported_key              false
keys                      map[1:1670984964 2:1670986091]
latest_version            2
min_available_version     0
min_decryption_version    1
min_encryption_version    0
name                      chacha
supports_decryption       true
supports_derivation       true
supports_encryption       true
supports_signing          false
type                      chacha20-poly1305
```

Change `min_decryption_version` property of the encryption key to version 2.

```
$ vault write transit/keys/chacha/config min_decryption_version=2
Success! Data written to: transit/keys/chacha/config
$ vault read transit/keys/chacha
Key                       Value
---                       -----
allow_plaintext_backup    false
auto_rotate_period        0s
deletion_allowed          false
derived                   false
exportable                false
imported_key              false
keys                      map[2:1670986091]
latest_version            2
min_available_version     0
min_decryption_version    2
min_encryption_version    0
name                      chacha
supports_decryption       true
supports_derivation       true
supports_encryption       true
supports_signing          false
type                      chacha20-poly1305
```

Version 1 of the encryption key has been deleted. You cannot use the corresponding ciphertext anymore to decrypt the value.

```
$ vault write transit/decrypt/chacha ciphertext=vault:v1:RWSTpSNEKqGUM3EJEA5cFE7yjf6Bz01F5ih7Tlz3wPYrsVY=
Error writing data to transit/decrypt/chacha: Error making API request.

URL: PUT http://127.0.0.1:8200/v1/transit/decrypt/chacha
Code: 400. Errors:

* ciphertext or signature version is disallowed by policy (too old)
```