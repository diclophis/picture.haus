#!/bin/sh

source ~/.bardin-haus-ec2-credentials.sh

export ANSIBLE_CONFIG=ansible/pipeline.cfg

ansible-playbook -vvvv -i ansible/inventory/local ansible/provision-playbook.yml
ansible-playbook -vvvv -i ansible/inventory/bardin-haus ansible/install-playbook.yml
