# Initializes Client VM

# Allows Trusted Entity to send the temporary token as a file
cat /home/vagrant/sync/ClientVM/ssh/unsafe_id_rsa.pub | cat >>  /home/vagrant/.ssh/authorized_keys
