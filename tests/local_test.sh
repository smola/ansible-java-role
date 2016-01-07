#!/bin/bash -xe

cd $(dirname $0)/../

for docker_image in $(grep -e '\- DOCKER_IMAGE=' .travis.yml | sed -e 's:.*DOCKER_IMAGE=\([^ ]*\).*:\1:g') ; do
	DOCKER_IMAGE=$docker_image
	docker run -t -v $(pwd)/../:/base $DOCKER_IMAGE /bin/bash -c "cd /base/ansible-java-role ; /bin/bash -xe tests/test.sh;"
done
