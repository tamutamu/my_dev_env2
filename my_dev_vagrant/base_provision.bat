vagrant destroy -f
vagrant up --provision-with kernel
vagrant reload
vagrant up --provision-with my_dev_base
vagrant halt
vagrant snapshot save --force base
