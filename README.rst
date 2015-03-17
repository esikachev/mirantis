System(scenario) tests for Sahara project
=========================================

How to run
----------

Create the yaml files for scenario tests ``etc/scenario/sahara-ci/simple-testcase.yaml``.
You can take a look at sample yaml files `How to write scenario files`_.

To run all integration tests you should use the corresponding tox env:

.. sourcecode:: console

    $ tox -e scenario
..

In this case all tests will be launched except disabled tests.

If you want to run integration tests for one plugin, you should use the
yaml file with scenario for this plugin:

.. sourcecode:: console

    $ tox -e scenario etc/scenario/sahara-ci/simple-testcase.yaml
..

For example, you want to run tests for the Vanilla plugin with the Hadoop
version 1.2.1. In this case you should use the following tox env:

.. sourcecode:: console

    $ tox -e scenario etc/scenario/sahara-ci/vanilla-1-2-1.yaml
..

If you want to run scenario tests for a few plugins or their versions, you
should use the several yaml files:

.. sourcecode:: console

    $ tox -e scenario etc/scenario/sahara-ci/vanilla-1-2-1.yaml etc/scenario/sahara-ci/vanilla-2-6-0.yaml ...
..

Here are a few more examples.

``tox -e scenario etc/scenario/sahara-ci/credential.yaml etc/scenario/sahara-ci/vanilla-2-6-0.yaml``
will run tests for Vanilla plugin with the Hadoop version 2.6.0 and credential
located in ``etc/scenario/sahara-ci/credential.yaml``.
More info about writing scenrio yaml file see in
section ``How to write scenario files``.

``tox -e scenario etc/scenario/sahara-ci`` will run tests from the test directory.

_`How to write scenario files`
------------------------------

You can write all sections in one or several files.


Section "credential"
--------------------

Required: os_username, os_password, os_tenant, os_auth_url.
This section is dictionary-type.

+-------------+---------------------------------+
|   Fields    |             Value               |
+=============+=================================+
| os_username | string, user name for login     |
+-------------+---------------------------------+
| os_password | string, password name for login |
+-------------+---------------------------------+
| os_tenant   | string, tenant name             |
+-------------+---------------------------------+
| os_auth_url | string, url for login           |
+-------------+---------------------------------+
| sahara_url  | string, url of sahara           |
+-------------+---------------------------------+


Section "network"
-----------------
Required: private_network, public_network.
This section is dictionary-type.

+-----------------------------+-------------------------------------+
|           Fields            |                Value                |
+=============================+=====================================+
| private_network             | string, name of private network     |
+-----------------------------+-------------------------------------+
| public_network              | string, name of private network     |
+-----------------------------+-------------------------------------+
| type                        | string, "neutron" or "nova-network" |
+-----------------------------+-------------------------------------+
| auto_assignment_floating_ip | boolean value                       |
+-----------------------------+-------------------------------------+


Section "clusters"
------------------

Required: plugin_name, plugin_version, image.
This section is array-type.

+---------------------+---------------------------------------------+
|        Fields       |                    Value                    |
+=====================+=============================================+
| plugin_name         | string, name of plugin                      |
+---------------------+---------------------------------------------+
| plugin_version      | string, version of plugin                   |
+---------------------+---------------------------------------------+
| image               | string, name of image                       |
+---------------------+---------------------------------------------+
| node_group_templates| object, see section `node_group_templates`_ |
+---------------------+---------------------------------------------+
| cluster_templates   | object, see section `cluster_templates`_    |
+---------------------+---------------------------------------------+
| cluster             | object, see `section "cluster"`_            |
+---------------------+---------------------------------------------+
| scaling             | object, see section `scaling`_              |
+---------------------+---------------------------------------------+
| scenario            | array, consists only of the values          |
|                     |                         "run_jobs", "scale" |
+---------------------+---------------------------------------------+
| edp_jobs_flow       | string, name of edp job flow                |
+---------------------+---------------------------------------------+
| retain_resources    | boolean value                               |
+---------------------+---------------------------------------------+


Section "node_group_templates"
------------------------------

Required: plugin_name, flavor_id, node_processes.
This section is array-type.

+---------------------------+--------------------------------------+
|           Fields          |                 Value                |
+===========================+======================================+
| name                      | string, name for node group template |
+---------------------------+--------------------------------------+
| flavor_id                 | string, id of flavor                 |
+---------------------------+--------------------------------------+
| node_processes            | string, name of process              |
+---------------------------+--------------------------------------+
| description               | string, description for node group   |
+---------------------------+--------------------------------------+
| volumes_per_node          | integer, minimum 0                   |
+---------------------------+--------------------------------------+
| volumes_size              | integer, minimum 0                   |
+---------------------------+--------------------------------------+
| auto_security_group       | boolean value                        |
+---------------------------+--------------------------------------+
| security_group            | array of security group              |
+---------------------------+--------------------------------------+
| node_configs              | name_of_config_section:              |
|                           |               config: value          |
+---------------------------+--------------------------------------+
| availability_zone         | string value                         |
+---------------------------+--------------------------------------+
| volumes_availability_zone | string value                         |
+---------------------------+--------------------------------------+
| volume_type               | string value                         |
+---------------------------+--------------------------------------+
| is_proxy_gateway          | boolean value                        |
+---------------------------+--------------------------------------+


Section "cluster_template"
--------------------------

Required: name, node_group_templates.
This section is dictionary-type.

+----------------------+-----------------------------------+
|        Fields        |               Value               |
+======================+===================================+
| name                 | string, name for cluster template |
+----------------------+-----------------------------------+
| description          | string, description               |
+----------------------+-----------------------------------+
| cluster_configs      | name_of_config_section:           |
|                      |                    config: value  |
+----------------------+-----------------------------------+
| node_group_templates | name_of_node_group: count         |
+----------------------+-----------------------------------+
| anti_affinity        | boolean value                     |
+----------------------+-----------------------------------+


Section "_`cluster`"
--------------------

Required: name.
This section is dictionary-type.

+--------------+--------------------------+
|    Fields    |           Value          |
+==============+==========================+
| name         | string, name for cluster |
+--------------+--------------------------+
| description  | string value             |
+--------------+--------------------------+
| is_transient | boolean value            |
+--------------+--------------------------+


Section "scaling"
-----------------

Required: operation, node_group, size
This section is array-type.

+------------+------------------------------+
|   Fields   |             Value            |
+============+==============================+
| operation  | string, "add" or "resize"    |
+------------+------------------------------+
| node_group | string, name of node group   |
+------------+------------------------------+
| size       | integer, count node group    |
+------------+------------------------------+


Section "edp_jobs_flow"
-----------------------

This section has object with name from section `clusters`_ field "edp_jobs_flow"
Object has sections of array-type.
Required: type

+-------------------+-------------------------------------------+
|       Fields      |                    Value                  |
+===================+===========================================+
| type              | string; "Pig", "Java", "MapReduce",       |
|                   |    "MapReduce.Streaming", "Hive", "Spark" |
+-------------------+-------------------------------------------+
| input_datasource  | object, see section ``input_datasource``  |
+-------------------+-------------------------------------------+
| output_datasource | object, see section ``output_datasource`` |
+-------------------+-------------------------------------------+
| main_lib          | object, see section ``main_lib``          |
+-------------------+-------------------------------------------+
| additional_libs   | object, see section ``additional_libs``   |
+-------------------+-------------------------------------------+
| configs           | dict, config: value                       |
+-------------------+-------------------------------------------+
| args              | array of args                             |
+-------------------+-------------------------------------------+


Section "input_datasource"
--------------------------

Required: type, source
This section is dictionary-type.

+--------+--------------------------+
| Fields |         Value            |
+========+==========================+
| type   | string, "swift or "hdfs" |
+--------+--------------------------+
| source | string, uri              |
+--------+--------------------------+


Section "output_datasource"
---------------------------

Required: type, destination
This section is dictionary-type.

+--------+--------------------------+
| Fields |         Value            |
+========+==========================+
| type   | string, "swift or "hdfs" |
+--------+--------------------------+
| source | string value             |
+--------+--------------------------+


Section "main_lib"
------------------

Required: type, source
This section is dictionary-type.

+--------+------------------------------+
| Fields |           Value              |
+========+==============================+
| type   | string, "swift or "database" |
+--------+------------------------------+
| source | string, uri                  |
+--------+------------------------------+


Section "additional_libs"
-------------------------

Required: type, source
This section is array-type.

+--------+------------------------------+
| Fields |           Value              |
+========+==============================+
| type   | string, "swift or "database" |
+--------+------------------------------+
| source | string, uri                  |
+--------+------------------------------+
