ssh-keygen -f keyname
#authorized key - key.pub
#prod - private key


sudo useradd dev-user

mkdir .ssh

chmod 700 .ssh/

vim .ssh/authorized_keys


chmod 400 .ssh/authorized_keys 

exit

exit



nano prod


chmod 400 prod




ssh -i prod dev-user@(ip of the system)
