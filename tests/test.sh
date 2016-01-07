#!/bin/bash -e

SITE=${SITE:-test.yml}

BASEDIR=$(dirname $0)

cd $BASEDIR

has_command() {
	command -v $1 &> /dev/null
}

# Detect platform
if [[ -e /etc/lsb-release ]] ; then
	source /etc/lsb-release
elif [[ -e /etc/oracle-release ]] ; then
	DISTRIB_ID=Oracle
	DISTRIB_RELEASE=$(sed -e 's:.* release \([0-9]*\).*:\1:g'  /etc/oracle-release)
elif [[ -e /etc/redhat-release ]] ; then
	DISTRIB_ID=$(cut /etc/redhat-release -f 1 -d ' ')
	DISTRIB_RELEASE=$(sed -e 's:.* release \([0-9]*\).*:\1:g'  /etc/redhat-release)
elif [[ -e /etc/debian_version ]] ; then
	DISTRIB_ID=Debian
	DISTRIB_RELEASE=$(sed -e 's:\([0-9]*\).*:\1:g' /etc/debian_version)
fi

if ! has_command ansible-playbook ; then
	if [[ $DISTRIB_ID = Ubuntu ]] ; then
		apt-get update
		apt-get install -y sudo python-pip python-crypto python-yaml python-paramiko python-jinja2 python-markupsafe python-httplib2 python-six
		if [[ $DISTRIB_RELEASE = 12.04 ]] ; then
			# Ubuntu 12.04 does not include a python-crypto recent enough, so pip will compile it.
			apt-get install -y python-dev build-essential
		fi
	elif [[ $DISTRIB_ID = Debian ]] ; then
		apt-get update
		apt-get install -y sudo python-pip python-crypto python-yaml python-paramiko python-jinja2 python-markupsafe python-httplib2 python-six
	elif [[ $DISTRIB_ID = CentOS ]] ; then
		yum install -y epel-release
		yum install -y sudo python python-pip python-crypto
		if [[ $DISTRIB_RELEASE = 6 ]] ; then
			# CentOS does not include a python-crypto recent enough, so pip will compile it.
			yum install -y python-devel
			yum groupinstall -y "Development Tools"
			# python-crypto needs to be removed: https://github.com/ansible/ansible/issues/276
			yum erase -y python-crypto
		fi
	else
		echo "Unsupported distro: $DISTRIB_ID $DISTRIB_RELEASE"
		exit 1
	fi

	# Install Ansible
	pip install ansible
fi

# Check the role/playbook's syntax.
ansible-playbook -i inventory $SITE --syntax-check

# Run the role/playbook with ansible-playbook.
ansible-playbook -vvvv -i inventory $SITE --connection=local --sudo

# Run the role/playbook again, checking to make sure it's idempotent.
ansible-playbook -vvvv -i inventory $SITE --connection=local --sudo \
  | grep -q 'changed=0.*unreachable=0.*failed=0'
if [[ $? = 0 ]] ; then
	echo 'Idempotence test: pass'
else
	echo 'Idempotente test: fail'
	exit 1
fi

# Make sure Java is installed.
if has_command java ; then
	echo 'Java is installed'
else
	echo 'Java is not installed'
	exit 1
fi

