#!/bin/bash

SITE=${SITE:-test.yml}

BASEDIR=$(dirname $0)

cd $BASEDIR

# Check the role/playbook's syntax.
ansible-playbook -i inventory $SITE --syntax-check

# Run the role/playbook with ansible-playbook.
ansible-playbook -i inventory $SITE --connection=local --sudo

# Run the role/playbook again, checking to make sure it's idempotent.
ansible-playbook -i inventory $SITE --connection=local --sudo \
  | grep -q 'changed=0.*failed=0' \
  && (echo 'Idempotence test: pass' && exit 0) \
  || (echo 'Idempotence test: fail' && exit 1)

# Make sure Java is installed.
which java \
  && (echo 'Java is installed' && exit 0) \
  || (echo 'Java is not installed' && exit 1)

