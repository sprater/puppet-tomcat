# == Define: install
#
# Install Tomcat on nodes from a binary distribution package.
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
#  String that specifies the user that will own the Tomcat installation.
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
# === Examples
#
# tomcat::install { 'example.com-tomcat':
#   source                     => 'apache-tomcat-7.0.39.tar.gz',
#   eploymentdir              => '/home/example.com/apps/apache-tomcat',
#   user                       => 'example.com',
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

define tomcat::install (
    $source                     = undef,
    $deploymentdir              = undef,
    $user                       = undef,
    $group                      = undef,
    $default_webapp_docs        = undef,
    $default_webapp_examples    = undef,
    $default_webapp_hostmanager = undef,
    $default_webapp_manager     = undef,
    $default_webapp_root        = undef,
) {

  # The base class must be included first because it is used by parameter defaults
  if ! defined(Class['tomcat']) {
    fail('You must include the apache base class before using any tomcat defined resources')
  }

  # We can get our params directly, or from the class
  $ti_source = $source? {
    undef => $::tomcat::source_real,
    default => $source
  }

  $ti_deploymentdir = $deploymentdir? {
    undef => $::tomcat::deploymentdir_real,
    default => $deploymentdir
  }

  $ti_user = $user? {
    undef => $::tomcat::user_real,
    default => $user
  }

  $ti_group = $group? {
    undef => $::tomcat::group_real,
    default => $group
  }

  $ti_default_webapp_docs = $default_webapp_docs? {
    undef => $::tomcat::default_webapp_docs_real,
    default => $default_webapp_docs
  }

  $ti_default_webapp_examples = $default_webapp_examples? {
    undef => $::tomcat::default_webapp_examples_real,
    default => $default_webapp_examples
  }

  $ti_default_webapp_hostmanager = $default_webapp_hostmanager? {
    undef => $::tomcat::default_webapp_hostmanager_real,
    default => $default_webapp_hostmanager
  }

  $ti_default_webapp_manager = $default_webapp_manager? {
    undef => $::tomcat::default_webapp_manager_real,
    default => $default_webapp_manager
  }

  $ti_default_webapp_root = $default_webapp_root? {
    undef => $::tomcat::default_webapp_root_real,
    default => $default_webapp_root
  }

  if ($caller_module_name == undef) {
    $mod_name = $module_name
  } else {
    $mod_name = $caller_module_name
  }

  $cachedir = "/var/lib/puppet/working-tomcat-${mod_name}"

  # working directory to untar tomcat
  file { $cachedir:
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  # resource defaults for Exec
  Exec {
    path => ['/sbin', '/bin', '/usr/sbin', '/usr/bin'],
  }

  file { "${cachedir}/${ti_source}":
    source  => "puppet:///modules/${mod_name}/${ti_source}",
    require => File[$cachedir],
  }

  exec { "extract_tomcat-${mod_name}":
    cwd     => $cachedir,
    command => "mkdir extracted; tar -C extracted -xzf ${source} && touch .tomcat_extracted",
    creates => "${cachedir}/.tomcat_extracted",
    require => File["${cachedir}/${source}"],
  }

  exec { "create_target_tomcat-${mod_name}":
    cwd     => '/',
    command => "mkdir -p ${ti_deploymentdir}",
    creates => $ti_deploymentdir,
    require => Exec["extract_tomcat-${mod_name}"],
  }

  exec { "move_tomcat-${mod_name}":
    cwd     => $cachedir,
    command => "cp -r extracted/apache-tomcat*/* ${ti_deploymentdir} && chown -R ${ti_user}:${ti_group} ${ti_deploymentdir}",
    creates => "${ti_deploymentdir}/lib/catalina.jar",
    require => Exec["create_target_tomcat-${mod_name}"],
  }

  if ($ti_default_webapp_docs == 'absent') {
    file { "${ti_deploymentdir}/webapps/docs":
      ensure  => absent,
      recurse => true,
      force   => true,
      require => Exec["move_tomcat-${mod_name}"],
    }
  }

  if ($ti_default_webapp_examples == 'absent') {
    file { "${ti_deploymentdir}/webapps/examples":
      ensure  => absent,
      recurse => true,
      force   => true,
      require => Exec["move_tomcat-${mod_name}"],
    }
  }

  if ($ti_default_webapp_hostmanager == 'absent') {
    file { "${ti_deploymentdir}/webapps/host-manager":
      ensure  => absent,
      recurse => true,
      force   => true,
      require => Exec["move_tomcat-${mod_name}"],
    }
  }

  if ($ti_default_webapp_manager == 'absent') {
    file { "${ti_deploymentdir}/webapps/manager":
      ensure  => absent,
      recurse => true,
      force   => true,
      require => Exec["move_tomcat-${mod_name}"],
    }
  }

  if ($ti_default_webapp_root == 'absent') {
    file { "${ti_deploymentdir}/webapps/ROOT":
      ensure  => absent,
      recurse => true,
      force   => true,
      require => Exec["move_tomcat-${mod_name}"],
    }
  }
}
