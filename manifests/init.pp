# == Class: tomcat
#
# The Tomcat module installs the Tomcat Java EE server from
# a source distribution.
#
# === Parameters
#
# [*source*]
#  String that specifies the file that contains the Tomcat binary distribution.
#  This file must be in the files directory in the caller module.
#  Only .tar.gz source archives are supported.
#
# [*deploymentdir*]
#  String that specifies the absolute path to the directory where Tomcat will
#  be installed.
#
# [*user*]
#  String that specifies the Unix user that will own the Tomcat installation.
#
# [*group*]
#  String that specifies the Unix group that will own the Tomcat installation.
#
# [*default_webapp_docs*]
#  String that specifies whether Tomcat's default webapp documentation should
#  be present or not. Valid arguments are "present" or "absent". Default is
#  "present".
#
# [*default_webapp_examples*]
#  String that specifies whether Tomcat's default example webapps should
#  be present or not. Valid arguments are "present" or "absent". Default is
#  "present".
#
# [*default_webapp_hostmanager*]
#  String that specifies whether Tomcat's default webapp for host
#  management should be present or not. Valid arguments are "present"
#  or "absent". Default is "present".
#
# [*default_webapp_manager*]
#  String that specifies whether Tomcat's default webapp for server
#  configuration should be present or not. Valid arguments are "present"
#  or "absent". Default is "present".
#
# [*default_webapp_root*]
#  String that specifies whether Tomcat's default webapp root directory
#  should be present or not. Valid arguments are "present"
#  or "absent". Default is "present".
#
# === Variables
#
# None at this time.
#
# === Examples
#
# class { tomcat:
#   source                     => 'apache-tomcat-7.0.39.tar.gz',
#   deploymentdir              => '/home/example.com/apps/apache-tomcat',
#   user                       => 'example.com',
#   group                      => 'mygroup',
#   default_webapp_docs        => 'present',
#   default_webapp_examples    => 'present',
#   default_webapp_hostmanager => 'present',
#   default_webapp_manager     => 'present',
#   default_webapp_root        => 'present'
# }
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
class tomcat (

  $source                     = 'UNSET',
  $deploymentdir              = 'UNSET',
  $user                       = 'UNSET',
  $group                      = 'UNSET',
  $default_webapp_docs        = 'UNSET',
  $default_webapp_examples    = 'UNSET',
  $default_webapp_hostmanager = 'UNSET',
  $default_webapp_manager     = 'UNSET',
  $default_webapp_root        = 'UNSET',

) {

  include stdlib
  include tomcat::params

  validate_re($tomcat::params::source, '.tar.gz$',
    'The Tomcat distribution file is not a tar-gzipped file.')
  validate_absolute_path($tomcat::params::deploymentdir)
  validate_string($tomcat::params::user)
  validate_string($tomcat::params::group)
  validate_re($tomcat::params::default_webapp_docs,
    [ 'present', 'absent' ])
  validate_re($tomcat::params::default_webapp_examples,
    [ 'present', 'absent' ])
  validate_re($tomcat::params::default_webapp_hostmanager,
    [ 'present', 'absent' ])
  validate_re($tomcat::params::default_webapp_manager,
    [ 'present', 'absent' ])
  validate_re($tomcat::params::default_webapp_root,
    [ 'present', 'absent' ])

  $source_real = $source? {
    'UNSET' => $::tomcat::params::source,
    default => $source,
  }

  $deploymentdir_real = $deploymentdir? {
    'UNSET' => $::tomcat::params::deploymentdir,
    default => $deploymentdir,
  }

  $user_real = $user? {
    'UNSET' => $::tomcat::params::user,
    default => $user,
  }

  $group_real = $group? {
    'UNSET' => $::tomcat::params::group,
    default => $group,
  }

  $default_webapp_docs_real = $default_webapp_docs? {
    'UNSET' => $::tomcat::params::default_webapp_docs,
    default => $default_webapp_docs,
  }

  $default_webapp_examples_real = $default_webapp_examples? {
    'UNSET' => $::tomcat::params::default_webapp_examples,
    default => $default_webapp_examples,
  }

  $default_webapp_hostmanager_real = $default_webapp_hostmanager? {
    'UNSET' => $::tomcat::params::default_webapp_hostmanager,
    default => $default_webapp_hostmanager,
  }

  $default_webapp_manager_real = $default_webapp_manager? {
    'UNSET' => $::tomcat::params::default_webapp_manager,
    default => $default_webapp_manager,
  }

  $default_webapp_root_real = $default_webapp_root? {
    'UNSET' => $::tomcat::params::default_webapp_root,
    default => $default_webapp_root,
  }

}
