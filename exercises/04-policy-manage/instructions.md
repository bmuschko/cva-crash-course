# Exercise 4

In this exercise, you will manage a policy without assigning it yet. You will define and format the contents of a policy file, and then create the policy in Vault. As part of the exercise, you will also list available policies and update the rules of an existing policy from the CLI and UI.

1. Log in with the root token.
2. List the current policies available.
3. Create a policy file named `mounts-list.hcl`. Define a rule for the path `sys/mounts` with the capability `read`.
4. Ensure that the format of the policy file follows the official style conventions.
5. Create the policy with the name `mounts-list`.
6. List all available policies. You should see the new policy. Render the details of the policy.
7. Sign into the Vault UI with the root token. Find the policy and inspect its details.
8. Update the policy by defining another rule. For the path `sys/mounts/*` add the capabilities `read`, `list`, and `sudo`. Add the new rule _before_ the existing rule.