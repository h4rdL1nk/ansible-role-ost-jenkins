Welcome to ansible-role-smd-mongodb Ansible Role
================================================

ansible-role-smd-mongodb
------------------------

XXROLEDESCRIPTIONXX

### Requirements

Docker engine up and running

### Dependencies

N/A

### Example Playbook

    - hosts: servers
      roles:
        - { role: ansible-role-smd-mongodb }

Default variables
-----------------

#### Sections

-   Configuration

### Configuration

`smd_mongodb_image`

> Docker image to use

    smd_mongodb_image: dockerhub.hi.inet/smartdigits/mongodb

`smd_mongodb_version`

> Docker image version

    smd_mongodb_version: latest

`smd_mongodb_bind_network`

> Inventory var that contains the ip where we listen

    smd_mongodb_bind_network: DOCKER_BACKEND

`smd_mongodb_bind_port`

> Port where container will listen

    smd_mongodb_bind_port: 27017

`smd_mongodb_memory_limit`

> Memory assigned to container in GB

    smd_mongodb_memory_limit: 4

`smd_mongodb_oom_killer_disable`

> Disable OutOfMemory killer on the container

    smd_mongodb_oom_killer_disable: True

`smd_mongodb_configure_replicaset`

> If true configure replicaset

    smd_mongodb_configure_replicaset: True

`smd_mongodb_ds_name`

> Datastorage name, when configuring replicaset this value should be the
> ansible group with the replicaset hosts

    smd_mongodb_ds_name: "ds2"

`smd_mongodb_ds_instance`

> Datastorage instance name

    smd_mongodb_ds_instance: "silver"

`smd_mongodb_replicaset`

> When configuring replicaset, the replicaset name

    smd_mongodb_replicaset: "{{smd_mongodb_ds_name}}_{{smd_mongodb_ds_instance}}"

`smd_mongodb_configure_lvm`

> Enable LVM volume creation

    smd_mongodb_configure_lvm: False

`smd_mongodb_lvm_pvs`

> LVM Physical volume device

    smd_mongodb_lvm_pvs: /dev/sdd

`smd_mongodb_lvm_pesize`

> LVM Physical extend size

    smd_mongodb_lvm_pesize: 32

`smd_mongodb_lvm_vgname`

> LVM Volume group name

    smd_mongodb_lvm_vgname: "vg_{{smd_mongodb_ds_name}}_{{smd_mongodb_ds_instance}}"

`smd_mongodb_lvm_lvname`

> LVM Volume name

    smd_mongodb_lvm_lvname: "lv_{{smd_mongodb_ds_name}}_{{smd_mongodb_ds_instance}}"

`smd_mongodb_lvm_lvsize`

> LVM Volume size

    smd_mongodb_lvm_lvsize: 100%FREE

`smd_mongodb_lvm_fs`

> When creating LVM this is the mountpoint of the created volume, also
> is the mongo data path attached to container

    smd_mongodb_lvm_fs: "/var/dockershared/storage/{{smd_mongodb_ds_name}}_{{smd_mongodb_ds_instance}}"

Changelog
---------

This project adheres to Semantic Versioning and human-readable
changelog.

### ansible-role-smd-mongodb master - 2017/09/18

##### Added

-   First addition

##### Changed

-   First change

### ansible-role-smd-mongodb v0.0.1 - 2017/09/18

##### Added

-   Initial version

Copyright
---------

ansible-role-smd-mongodb Ansible Role

Copyright (c) 2017, Fernando Gonzalez
\<<fernando.gonzalezlara.ext@telefonica.com>\>

Telefonica I+D
