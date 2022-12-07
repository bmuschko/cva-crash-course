# Exercise 9

In this exercise, you will enable the AWS secrets engine in Vault. You will then create a dynamic secret in the secrets store and inspect its properties. Reference the relevant [Vault documentation](https://developer.hashicorp.com/vault/docs/secrets/aws) for more information.

> **_NOTE:_** You will need a [AWS account](https://aws.amazon.com/) for this exercise. I recommend signing up for the free tier which lets you use the account without accruing costs.

1. Log in with the root token.
2. Enable the AWS secrets engine with the path `aws`.
3. Configure the credentials that Vault uses to communicate with AWS to generate the IAM credentials using the `write aws/config/root` path. Set the region to `us-west-2`.
4. Configure a Vault role that maps to a set of permissions in AWS as well as an AWS credential type. The path should be `aws/roles/foo`. Provide the following policy document:

```json
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
```

5. Generate a new credential by reading from the `aws/creds` endpoint with the name of the role.
6. Change the lease configuration by setting `lease` to 30m and `lease_max` to 30m.
7. Generate a new credential and check the lease configuration.
8. List all available leases and see how many you have available.
9. Revoke all leases for AWS credentials.