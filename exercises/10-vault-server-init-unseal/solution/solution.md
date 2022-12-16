# Solution

Create the server configuration file. You can find an example of such a file [here](vault-server-config.hcl).

Before starting the server, create the directory for the storage backend.

```
$ mkdir -p ./vault/data
```

Start the server by pointing to the configuration file.

```
$ vault server -config=vault-server-config.hcl
WARNING! mlock is not supported on this system! An mlockall(2)-like syscall to
prevent memory from being swapped to disk is not supported on this system. For
better security, only run Vault on systems where this call is supported. If
you are running Vault in a Docker container, provide the IPC_LOCK cap to the
container.
==> Vault server configuration:

             Api Address: http://127.0.0.1:8200
                     Cgo: disabled
         Cluster Address: https://127.0.0.1:8201
              Go Version: go1.19.3
              Listener 1: tcp (addr: "127.0.0.1:8200", cluster address: "127.0.0.1:8201", max_request_duration: "1m30s", max_request_size: "33554432", tls: "disabled")
               Log Level: info
                   Mlock: supported: false, enabled: false
           Recovery Mode: false
                 Storage: file
                 Version: Vault v1.12.1, built 2022-10-27T12:32:05Z
             Version Sha: e34f8a14fb7a88af4640b09f3ddbb5646b946d9c+CHANGES

==> Vault server started! Log data will stream in below:

2022-12-16T11:32:07.596-0700 [INFO]  proxy environment: http_proxy="" https_proxy="" no_proxy=""
2022-12-16T11:32:07.596-0700 [INFO]  core: Initializing version history cache for core
```

Ensure to export the environment variable `VAULT_ADDR` pointing to the HTTP address of the server. Initialize the Vault with 3 unseal keys and a key threshold of 2.

```
$ export VAULT_ADDR='http://127.0.0.1:8200'
$ vault operator init -key-shares=3 -key-threshold=2
Unseal Key 1: CEKE8VSHj0dozR7248+7YHLT0+MznmXC1/15yYlt/nxq
Unseal Key 2: cDo8pMltJqmpPqZQr/cptVgCpPYno0do68GSUAYz65fQ
Unseal Key 3: 2ZNvyBPjaQHX4PXikwgOdSzk8MyZ/n+wMhiYrFeE0Z2Q

Initial Root Token: hvs.ogeZ5LjMVQZDwLj2k1MWndyu

Vault initialized with 3 key shares and a key threshold of 2. Please securely
distribute the key shares printed above. When the Vault is re-sealed,
restarted, or stopped, you must supply at least 2 of these keys to unseal it
before it can start servicing requests.

Vault does not store the generated root key. Without at least 2 keys to
reconstruct the root key, Vault will remain permanently sealed!

It is possible to generate new unseal keys, provided you have a quorum of
existing unseal keys shares. See "vault operator rekey" for more information.
```

Execute the `operator unseal` command two times. Provide different unseal keys per invocation.

```
$ vault operator unseal
Unseal Key (will be hidden): CEKE8VSHj0dozR7248+7YHLT0+MznmXC1/15yYlt/nxq
Key                Value
---                -----
Seal Type          shamir
Initialized        true
Sealed             true
Total Shares       3
Threshold          2
Unseal Progress    1/2
Unseal Nonce       2149894b-2de6-af6f-bb76-eabcdd0ea64a
Version            1.12.1
Build Date         2022-10-27T12:32:05Z
Storage Type       file
HA Enabled         false
$ vault operator unseal
Unseal Key (will be hidden): cDo8pMltJqmpPqZQr/cptVgCpPYno0do68GSUAYz65fQ
Key             Value
---             -----
Seal Type       shamir
Initialized     true
Sealed          false
Total Shares    3
Threshold       2
Version         1.12.1
Build Date      2022-10-27T12:32:05Z
Storage Type    file
Cluster Name    vault-cluster-c7fc4948
Cluster ID      5696e522-4fab-309f-4a3c-105828e0f41c
HA Enabled      false
```

Open the browser at [http://127.0.0.1:8200](http://127.0.0.1:8200). Select the method "Token" and enter the intial root token value. In this case, the value is `hvs.ogeZ5LjMVQZDwLj2k1MWndyu`. Click on the "Sign In" button.