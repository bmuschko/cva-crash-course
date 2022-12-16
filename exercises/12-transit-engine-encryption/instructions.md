# Exercise 12

In this exercise, you will use the Transit engine for encryption/decryption purposes.

1. Log in with the root token.
2. Enable the Transit engine with the path `transit`.
3. Create an encryption key named `chacha` of type `chacha20-poly1305`. Check the details of the encryption key.
4. Encrpyt the value `abc123` using the encryption key named `chacha`.
5. Decrypt the value `abc123` using the ciphertext with the encryption key named `chacha`.
6. Rotate the encryption key. Check the details of the encryption key.
7. Change `min_decryption_version` property of the encryption key to version 2. Can you still decrypt the value `abc123` with the ciphertext from version 1?