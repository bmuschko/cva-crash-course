# Solution

Create a new secret using the `kv put` command.

```
$ vault kv put app-kv/ext-service api-key=iRJgazGtbjC9pLZCZnTMRtPk
Success! Data written to: app-kv/ext-service
```

You can view the secret using the `kv get` command.

```
$ vault kv get app-kv/ext-service
===== Data =====
Key        Value
---        -----
api-key    iRJgazGtbjC9pLZCZnTMRtPk
```

Individual fields can be accessed by providing the `-field` option.

```
$ vault kv get -field=api-key app-kv/ext-service
iRJgazGtbjC9pLZCZnTMRtPk
```

Adding a new value for the key `api-key` will overwrite the existing entry.

```
$ vault kv put app-kv/ext-service api-key=new
Success! Data written to: app-kv/ext-service
```

You can see the result by running the `kv get` command again.

```
$ vault kv get app-kv/ext-service
===== Data =====
Key        Value
---        -----
api-key    new
```

Right now, the kv secrets engine is based on version 1. You can enable version for the secrets engine with the following command. The existing entries will be stored as version 1 of the secret.

```
$ vault kv enable-versioning app-kv
Success! Tuned the secrets engine at: app-kv/
```

Adding a new value for the key `api-key` will create version 2 of the entry.

```
$ vault kv patch app-kv/ext-service api-key=patched
===== Secret Path =====
app-kv/data/ext-service

======= Metadata =======
Key                Value
---                -----
created_time       2022-12-05T23:30:01.180985Z
custom_metadata    <nil>
deletion_time      n/a
destroyed          false
version            2
```

You can find the current version in the metadata.

```
$ vault kv get app-kv/ext-service
===== Secret Path =====
app-kv/data/ext-service

======= Metadata =======
Key                Value
---                -----
created_time       2022-12-05T23:30:01.180985Z
custom_metadata    <nil>
deletion_time      n/a
destroyed          false
version            2

===== Data =====
Key        Value
---        -----
api-key    patched
```

To get back to version 1 of the secret, simply provide the version as CLI option.

```
$ vault kv get -field=api-key -version=1 app-kv/ext-service
new
```

Destroying a specific version with the `kv destroy` command will permanently delete the entry. It cannot be undeleted anymore. If that's the intention, then you should use the `kv delete` command.

```
$ vault kv destroy -versions=2 app-kv/ext-service
Success! Data written to: app-kv/destroy/ext-service
```

The metadata of the secret will reveal that version 2 has been destroyed, and the oldest available version is 1.

```
$ vault kv metadata get app-kv/ext-service
====== Metadata Path ======
app-kv/metadata/ext-service

========== Metadata ==========
Key                     Value
---                     -----
cas_required            false
created_time            2022-12-05T23:27:15.907152Z
current_version         2
custom_metadata         <nil>
delete_version_after    0s
max_versions            0
oldest_version          1
updated_time            2022-12-05T23:30:01.180985Z

====== Version 1 ======
Key              Value
---              -----
created_time     2022-12-05T23:27:15.907152Z
deletion_time    n/a
destroyed        false

====== Version 2 ======
Key              Value
---              -----
created_time     2022-12-05T23:30:01.180985Z
deletion_time    n/a
destroyed        true
```