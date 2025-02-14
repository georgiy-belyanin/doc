.. _tt-start:

Starting Tarantool applications
===============================

..  code-block:: console

    $ tt start [APPLICATION[:APP_INSTANCE]]

``tt start`` starts Tarantool applications. The application files must be stored
inside the ``instances_enabled`` directory specified in the :ref:`tt configuration file <tt-config_file_app>`.
For detailed instructions on preparing and running Tarantool applications, see
:ref:`admin-instance-environment-overview` and :ref:`admin-start_stop_instance`.

See also: :ref:`tt-stop`, :ref:`tt-restart`, :ref:`tt-status`.

To start all instances of the application stored in the ``app`` directory inside
``instances_enabled`` in accordance with its ``instances.yml``:

..  code-block:: console

    $ tt start app

To start all instances of the ``app`` application appending their logs to stdout
(in the interactive mode):

..  code-block:: console

    $ tt start -i app

To start the ``router`` instance of the ``app`` application:

..  code-block:: console

    $ tt start app:router

When called without arguments, starts all enabled applications in the current environment:

..  code-block:: console

    $ tt start

.. _tt-start-app-layout:

Application layout
------------------

``tt start`` can start entire Tarantool clusters based on their YAML configurations.
A cluster application directory inside ``instances_enabled`` must contain the following files:

*   ``config.yaml`` -- a :ref:`YAML configuration <configuration>` that defines
    the cluster topology and settings.
    It can either contain an explicit configuration in the YAML format or point
    to a centralized configuration storage (for Enterprise Edition).
*   ``instances.yml`` -- a file that defines the list of cluster instances to run
    in the current environment.
*   (Optionally) ``*.lua`` files with code to load and run in the cluster.

For more information about Tarantool application layout, see :ref:`admin-instance-environment-overview`.

.. note::

    ``tt`` also supports Tarantool applications with :ref:`configuration in code <configuration_code>`,
    which is considered a legacy approach since Tarantool 3.0. For information
    about using ``tt`` with such applications, refer to the Tarantool 2.11 documentation.

.. _tt-start-background:

Running in the background
-------------------------

``tt start`` runs Tarantool applications in the background and uses its own watchdog
process for status checks (:ref:`tt status <tt-status>`) and application stopping (:ref:`tt stop <tt-stop>`).

.. important::

    Do not switch on the background mode using the cluster configuration
    (``process.background: true`` in the YAML configuration) or code (``box.cfg.background = true``)
    in applications that you run with ``tt``.
    If you start such an application with ``tt start``, ``tt`` won't be able to check
    the application status or stop it using the corresponding commands.

.. _tt-start-integrity-check:

Integrity check
---------------

..  admonition:: Enterprise Edition
    :class: fact

    The integrity check functionality is supported by the `Enterprise Edition <https://www.tarantool.io/compare/>`_ only.

``tt start`` can perform initial and periodical integrity checks of the environment,
application, and centralized configuration.

To enable integrity checks of environment and application files, you need to pack
the application using ``tt pack`` with the ``--with-integrity-check`` option.
This option generates and signs checksums of executables and configuration files in the current ``tt``
environment. Learn more in :ref:`tt-pack-integrity-check`.

To enable integrity check of the configuration at the centralized storage,
publish the configuration to this storage using ``tt cluster publish`` with the ``--with-integrity-check`` option.
This option generates and signs configuration checksums and saves them to the storage.
Learn more in :ref:`tt-cluster-publish-integrity`.

To perform the integrity checks when running the application, start it with the
``--integrity-check`` :ref:`global option <tt-global-options>`.
Its argument must be a public key matching the private key that was used for
generating checksums.

..  code-block:: console

    $ tt --integrity-check public.pem start myapp

After such a call, ``tt`` checks the environment, application, and configuration integrity
using the checksums and starts the application in case of the success. Then, integrity
checks are performed periodically while the application is running. By default,
they are performed once every 24 hours. You can adjust the integrity check period
by adding the ``--integrity-check-period`` option:

..  code-block:: console

    $ tt --integrity-check public.pem start myapp --integrity-check-period 60

Additionally, Tarantool checks the integrity of the modules that the application uses
at the load time, that is, when ``require('module')`` is called.

If an integrity check fails, ``tt`` stops the application.

.. _tt-start-options:

Options
-------

..  option:: -i, --interactive

    Start the application or instance in the interactive mode.
    In this mode, instance logs are printed to the standard output in real time.

    You can use the ``SIGINT`` signal (``CTRL+C``) to stop ``tt`` and its child
    Tarantool processes in the interactive mode. No watchdog processes are created.

..  option:: --integrity-check-interval NUMBER

    Integrity check interval in seconds. Default: 86400 (24 hours).
    Set this option to ``0`` to disable periodic checks.

    See also: :ref:`tt-start-integrity-check`