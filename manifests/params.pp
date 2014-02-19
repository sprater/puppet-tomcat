# == Class: tomcat::params
#
# Configuration parameters for the tomcat module
#
# === Parameters
#
# === Variables
#
# === Examples
#
# === Authors
#
# Francis Pereira <francispereira@7terminals.com>
# Scott Prater <sprater@gmail.com>
#
# === Copyright
#
# Copyright 2014 Francis Pereira, Scott Prater
#
class tomcat::params {

    $source                     = 'apache-tomcat-7.0.50.tar.gz'
    $deploymentdir              = '/opt/tomcat7'
    $user                       = 'tomcat'
    $group                      = 'tomcat'
    $default_webapp_docs        = 'present'
    $default_webapp_examples    = 'present'
    $default_webapp_hostmanager = 'present'
    $default_webapp_manager     = 'present'
    $default_webapp_root        = 'present'
}
