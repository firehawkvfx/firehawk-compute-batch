cd /vagrant
ansible-playbook -i ansible/inventory/hosts ansible/init.yaml -v
ansible-playbook -i ansible/inventory/hosts ansible/newuser_deadline.yaml -v
ansible-playbook -i ansible/inventory/hosts ansible/openfirehawkserver_houdini.yaml -v
terraform apply --auto-approve