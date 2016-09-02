# Downloads and installs Hashicorp vault

yum install wget -y
wget --quiet https://releases.hashicorp.com/vault/0.6.1/vault_0.6.1_linux_amd64.zip
yum install unzip -y
unzip vault_0.6.1_linux_amd64.zip
