# Hashicorp Vault PoC using Token Authentication

### This is a demo showing how to use Hashicorp Vault with Token Authentication.

### This project uses insecure configuration, it is intended for educational purposes only.

### Requirements
- Tested with Vagrant 1.8.1
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads) installed
- Enough RAM if running all VMs

## Hashicorp Vault
### Installation
1. Go to the HashicorpVault folder and start the VMs

    ````
    cd HashicorpVault
    vagrant up
    ````
### Manual steps to initialize the Vault (only needed once)
#### Unseal
1. Execute to log into the VM

    ````
    vagrant ssh hashicorp-vault
    ````
2. Execute

    ````
    ./vault server -config=sync/HashicorpVault/config.hcl
    ./vault init
    ````
3. Write down the generated tokens, which will be needed to seal/unseal the vault in the future
4. Execute this command three times, entering one of the provided tokens:

    ````
    ./vault unseal
    ````
#### Enable AppRole Authentication
1. Authenticate using root token provided at start:

    ````
    ./vault auth [root token]
    ````
2. Enable auditing log

    ```
    ./vault audit-enable file path=./vault_audit.log
    ```
3. Check existing secret 'folders':

    ```
    ./vault mounts
    ```
#### Add policies
Execute:

```
./vault policy-write production sync/HashicorpVault/policies/production.hcl
./vault policy-write qa sync/HashicorpVault/policies/qa.hcl
./vault policy-write development sync/HashicorpVault/policies/development.hcl
```

#### Write sample secrets
Execute:

```
./vault write secret/production/password value=MyProdPassword
./vault write secret/production/qa value=MyQAPassword
./vault write secret/production/development value=MyDevelopmentPassword
```

#### Bootstrapping to allow a Node/ app using tokens
1. Create token, and wrap results using Cubbyhole

   ```
   ./vault token-create -policy=production -wrap-ttl=20m
   ```

   *Optional arguments*

   - _explicit_max_ttl_ - Sets the time after which this token can never be renewed.
   - _num_uses_ - Number of times this token can be used. Default is unlimited.
   - _renewable_ - If token is renewable or not. Default is true.
   - _ttl_ - Time token is valid. Default is 720hs.

2. This returns a cubbyhole token with time to live. This is a single use token.
3. Send token to Node
4. Node issues

    ```
    curl \
        -H "X-Vault-Token: [cubbyhole token]" \
        -X GET \
        http://192.168.0.50:8200/v1/cubbyhole/response
    ```
    This will return a json containing the access token and lease renewal token.
    If returns permission denied, token either expired or compromised. Notify Vault to revoke that token and create a new one.
5. Now whenever Node wants to talk to Vault, it should use its token on the X-Vault-Token header
6. This token has ttl and will expire in 720hs. In order to keep alive, Node must issue
    ```
    curl \
        -H "X-Vault-Token: [token]" \
        -X POST \
        http://192.168.0.50:8200/v1/auth/token/renew-self
    ```
    Not that this is not the cubbyhole token, it is the token that was wrapped in that token.
    Lease renewal is only possible if token still valid. If expired or revoked, notify Higher Level Authority (Jenkins) and go back to step 1.

## Troubleshooting
Error:
_Error initializing Vault: Put https://127.0.0.1:8200/v1/sys/init: http: server gave HTTP response to HTTPS client_

Solution:
You are trying to use Vault in the host without setting the environment variable. Run:
```
export VAULT_ADDR=http://0.0.0.0:8200
```
