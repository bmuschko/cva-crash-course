# Exercise 4

In this exercise, you will manage a policy for a user created with the Userpass authentication method. You will create, list, inspect the policy.

1. Log in with the root token.
2. List the current policies available.
3. Create a policy file named `secrets-list.hcl`. Define a rule for the path `sys/mounts` with the capability `read`.
4. Ensure that the format of the policy file follows the official style conventions.
5. Create the policy with the name `secrets-list`.
6. List all available policies. You should see the new policy. Render the details of the policy.
7. Sign into the Vault UI with the root token. Find the policy and inspect its details.
8. Update the policy by defining another rule. For the path `sys/mounts/*` add the capabilities `read`, `list`, and `sudo`.