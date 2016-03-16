#!/bin/sh

source ~/.picture-haus-env.sh

export ANSIBLE_CONFIG=ansible/pipeline.cfg

ansible-playbook -vvvv -i ansible/inventory/local ansible/provision-playbook.yml
ansible-playbook -vvvv -i ansible/inventory/picture-haus ansible/install-playbook.yml
