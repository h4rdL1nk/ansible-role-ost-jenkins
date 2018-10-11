|app|
=====

Deploy and configure mongodb containers with or without replicaset configuration.

Requirements
------------

Docker engine up and running

Dependencies
------------

N/A

Example Playbook
----------------

.. code::

  - hosts: servers
    roles:
      - { role: ansible-role-smd-mongodb }

