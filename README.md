Ansible Java Role
=================

[![Build Status](https://travis-ci.org/smola/ansible-java-role.svg?branch=master)](https://travis-ci.org/smola/ansible-java-role)

Manages installation of Java JREs and JDKs. It supports both OpenJDK and Oracle
JRE and JDK 6, 7 and 8. All of them are installed using the package manager.

Requirements
------------

None.

Role Variables
--------------

The `java_packages` variable must be set to a list of the desired Java packages. For example:

```yaml
java_packages:
  - openjdk-6-jdk
  - oracle-java7-installer
```

# Debian / Ubuntu

Valid packages for Debian and Ubuntu are:

- openjdk-6-jre
- openjdk-6-jre-headless
- openjdk-6-jdk
- openjdk-7-jre
- openjdk-7-jre-headless
- openjdk-7-jdk
- oracle-java6-installer
- oracle-java7-installer
- oracle-java8-installer

32bit Java may be installed on x86 platforms appending `:i386` to the package name.

You can ensure that Oracle JDK is set as the default JDK by adding `oracle-java6-set-default`, `oracle-java7-set-default` or `oracle-java6-set-default` to the `java\_packages` list.

# Fedora

Valid packages for Fedora are:

- java-1.7.0-openjdk
- java-1.8.0-openjdk

# Others

Got this role working with a different distro? Please, [report it on GitHub](http://github.com/smola/ansible-java-role/issues) or drop me a line at santi@mola.io.

Dependencies
------------

None.

Example Playbook
-------------------------

    - hosts: servers
      roles:
         - { role: smola.java }

License
-------

Copyright (c) Santiago M. Mola <santi@mola.io>

ansible-java-role is released under the terms of the MIT License.


Acknowledgements
----------------

Thanks to Jeff Geerling ([@geerlingguy](https://github.com/geerlingguy)) from whom I have borrowed some ideas from his [ansible-java-role](https://github.com/geerlingguy/ansible-role-java) and [Testing Ansible Roles with Travis CI on GitHub](https://servercheck.in/blog/testing-ansible-roles-travis-ci-github).
