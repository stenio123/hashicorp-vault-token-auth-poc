title Secrets Management Workflow

Trusted Entity->Hashicorp Vault: Initialize Vault
Trusted Entity->Hashicorp Vault: Create Policies
Trusted Entity->Hashicorp Vault: Requests Token creation w/ Policy
Hashicorp Vault->Trusted Entity: Returns single-use wrapper token
note right of Trusted Entity: Policy to be associated with\nspecific token comes from\nVM definition
Trusted Entity->VM: Bootstraps VM, passing wrapped token
VM->Hashicorp Vault: Unwraps token, gets access token and lease
VM->VM: Stores token in memory
VM->Hashicorp Vault: Gets secrets
VM->Hashicorp Vault: At recurring intervals,\nrequests access token renewal
