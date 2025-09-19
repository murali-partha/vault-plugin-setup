# Vault Plugin Setup

This is a simple terraform module to setup a Vault server with external plugins registered. The intention of the module is for development and demonstration use only and is nowhere close to be used in production. 

## Characterstics:

1. Single node Vault server
2. TLS disabled
3. Raft storage backend
4. External plugins downloaded and registered. 

## Usage

The module currently supports only AWS as the cloud provider and requires the necessary credentials to be set.

```
ex : export AWS_ACCESS_KEY_ID=...
export AWS_SECRET_ACCESS_KEY=... 
export AWS_SESSION_TOKEN=...
```

All configurable parameters are present in the values.tfvars file and can be set as per user preferences. All values also have defaults and is only optional to be set by the user.

Run the terraform commands as below to deploy the cluster

```
$ terraform init 

$ terraform apply // for default configs

or 

$ terraform apply -var-file=values.tfvars // for user input values
```

After the resources are successully created, the output contains the public address of the cluster and an ssh key `vault-ssh-private.key` is created in the current directory to login to the cluster. 

Another file named `vault-init.json` is also generated, this contains the unseal keys and root token for the cluster ( it is highly discouraged to save sensitive data on disk, this is only for the extra convinience during development ). 

You can ssh into the cluster using

```
ssh -o StrictHostKeyChecking=no -i ./vault-ssh-private.key ubuntu@<public_addr>
```