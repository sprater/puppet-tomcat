####Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Prerequisites](#prerequisites)
3. [Setup - The basics of getting started with tomcat](#setup)
    * [What tomcat affects](#what-tomcat-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with tomcat](#beginning-with-tomcat)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

##Overview

The tomcat module installs the Apache Tomcat binary distribution.

##Module Description

The Tomcat module installs the Apache Tomcat binary distribution onto your nodes.
You may set the Tomcat binary distribution package, the directory into which
it will install, the user that will own the package, and whether or not a number
of default Tomcat resources will be installed as well.

##Prerequisites

You'll also need to download the Apache Tomcat binary distribution package:

 * Tomcat 7:  <http://tomcat.apache.org/download-70.cgi>

Choose the correct *.tar.gz package for your platform.  Only `*.tar.gz`
packages are supported at this time.
   
##Setup

###What tomcat affects

* Tomcat base directory

This module installs a standalone version of Apache Tomcat, separate
from any OS-supplied Tomcat package.

It should work on any Unix environment.

###Beginning with tomcat

####Build and install the module

1. Clone this project, change to the `puppet-tomcat` directory. 

2. Copy the binary distribution file you downloaded (see 
[Prerequisites](#prerequisites), above) into the caller module's `files/` 
directory:

```
    cp /path/to/source/packages/*.tar.gz files/
```

3. Build the module: 

```
    puppet module build .
```

4. Install the module:

```
    sudo puppet module install pkg/7terminals-tomcat-<version>.tar.gz --ignore-dependencies
```

   where `<version>` is the current version of the module.

####Enable the module in Puppet

`include 'tomcat'` in the puppet master's `site.pp` file is enough to get 
you up and running.  It can also be included in any other caller module.

##Usage

##Reference

###Classes

####Public Classes

* tomcat:  Main class, includes all other classes

####Private Classes

* tomcat::install: Creates the user and group, ensures that the correct
  directories exist, and installs the base software and the Fedora WAR.
* tomcat::params:  The default configuration parameters.

###Parameters

The following parameters are available in the tomcat module.

The defaults are defined in `tomcat::params`, and may be changed there, or
overridden in the Puppet files that include the `tomcat` class.

#####`source`

The file that contains the Tomcat binary distribution.
This file must be in the files directory in the caller module.  
Only `.tar.gz` source archives are supported.

Default: **apache-tomcat-7.0.50.tar.gz**

#####`deploymentdir`

The absolute path to the directory where Tomcat will be installed.

Default: **/opt/tomcat7**

#####`user`

The Unix user that will own the Tomcat installation.

Default: **tomcat**

#####`default_webapp_docs`

Whether Tomcat's default webapp documentation should
be present or not. Valid arguments are "present" or "absent".

Default: **present**

#####`default_webapp_examples`

Whether Tomcat's default example webapps should
be present or not. Valid arguments are "present" or "absent".

Default: **present**

#####`default_webapp_hostmanager`

Whether Tomcat's default webapp for host management should be present or not.
Valid arguments are "present" or "absent".

Default: **present**

#####`default_webapp_manager`

Whether Tomcat's default webapp for server configuration should be present or not.
Valid arguments are "present" or "absent".

Default: **present**

#####`default_webapp_root`

Whether Tomcat's default webapp root directory should be present or not. 
Valid arguments are "present" or "absent".

Default: **present**

##Limitations

This module does not define the raw filesystem devices, nor mount
any filesystems.  Nor dies it create nor ensure the Unix user.
Make sure the filesystem in which the Tomcat install will reside
is created and mounted, and that the Unix user exists.

This module assumes that the Unix group ID is the same as the Unix user ID.

This module has been built and tested using Puppet 3.4.x. on RHEL6.  It should
work on all Unices, but your mileage may vary.

##Development

See https://github.com/7terminals/puppet-tomcat
