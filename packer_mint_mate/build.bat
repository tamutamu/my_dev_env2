packer build -var-file=mint-mate-19.0.json core_template.json > build.log 2>&1

vagrant box add mint-mate-19.0 .\mint-mate.box

del .\mint-mate.box