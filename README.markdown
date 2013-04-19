tomcat
====


Overview
--------

The Apache Tomcat module installs and maintains the configuration of the Tomcat Jave EE server.


Module Description
-------------------

The Apache Tomcat module allows Puppet to install, configure and maintain the Tomcat Java EE server.

Setup
-----

**What tomcat affects:**

* installation directory for Tomcat
* init script located in /etc/init.d/
	
### Beginning with Apache Tomcat

To setup Apache Tomcat on a server

    tomcat::setup { 'example.com-tomcat':
      ensure        => 'running',
      enable        => true,
      source        => 'apache-tomcat-7.0.39.tar.gz',
      deploymentdir => '/home/example.com/apps/apache-tomcat',
      user          => 'example.com',
      serverxml     => 'example.com-server.xml',
      webxml        => 'example.com-web.xml',
      init_script   => 'example.com-init_script',
      default_webapp_docs        => 'present',
      default_webapp_examples    => 'present',
      default_webapp_hostmanager => 'present',
      default_webapp_manager     => 'present',
      default_webapp_root        => 'present'
    }

Usage
------

The `tomcat::setup` resource definition has several parameters to assist installation of tomcat.

**Parameters within `tomcat`**

####`ensure`

This parameter specifies whether the tomcat service should be running or not.
Valid arguments are "running" or "stopped". Default "running"

####`enable`

This parameter specifies whether tomcat should be enabled to start automatically on system boot.
Valid arguments are true or false. Default true

####`source`

This parameter specifies the source for the tomcat archive. 
This file must be in the files directory in the caller module. 
Only .tar.gz source archives are supported.

####`deploymentdir`

This parameter specifies the directory where tomcat will be installed.

####`user`

This parameter is used to set the permissions for the installation directory of tomcat.

####`serverxml`

This parameter specifies the server.xml file to be placed in the deployed tomcat installation.
This file must be in the files directory in the caller module.

####`webxml`

This parameter specifies the web.xml file to be placed in the deployed tomcat installation.
This file must be in the files directory in the caller module.

####`default_webapp_docs`
This parameter specifies whether tomcat's default web app documentation should be present or not.
Valid arguments are "present" or "absent". Default "present"

####`default_webapp_examples`
This parameter specifies whether tomcat's default example web apps should be present or not.
Valid arguments are "present" or "absent". Default "present"

####`default_webapp_hostmanager`
This parameter specifies whether tomcat's default web app for host management should be present or not.
Valid arguments are "present" or "absent". Default "present"

####`default_webapp_manager`
This parameter specifies whether tomcat's default web app for server configuration should be present or not.
Valid arguments are "present" or "absent". Default "present"

####`default_webapp_root`
This parameter specifies whether tomcat's default web app root directory should be present or not.
Valid arguments are "present" or "absent". Default "present"


Limitations
------------

This module has been built and tested using Puppet 2.6.x, 2.7, and 3.x.

The module has been tested on:

* CentOS 5.9
* CentOS 6.4
* Debian 6.0 
* Ubuntu 12.04

Testing on other platforms has been light and cannot be guaranteed. 

Development
------------

Bug Reports
-----------

Release Notes
--------------

**0.1.0**

First initial release.
