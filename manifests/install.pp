# == Class: tomcat::install
#
# Install the Tomcat binary distribution
# Parameters are set in class tomcat
#
# === Parameters
#
# === Variables
#
# [*cachedir*]
#  The temporary directory where the Tomcat binary distribution file will be
#  unpacked.

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

class tomcat::install inherits tomcat {

  include tomcat


  if ($caller_module_name == undef) {
    $mod_name = $module_name
  } else {
    $mod_name = $caller_module_name
  }

  $cachedir = "/var/lib/puppet/working-tomcat-${::tomcat::install::mod_name}"

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

  file { "${::tomcat::install::cachedir}/${::tomcat::source_real}":
    source  => "puppet:///modules/${::tomcat::install::mod_name}/${::tomcat::source_real}",
    require => File[$::tomcat::install::cachedir],
  }

  exec { "extract_tomcat-${::tomcat::install::mod_name}":
    cwd     => $::tomcat::install::cachedir,
    command => "mkdir extracted; tar -C extracted -xzf ${::tomcat::source_real} && touch .tomcat_extracted",
    creates => "${::tomcat::install::cachedir}/.tomcat_extracted",
    require => File["${::tomcat::install::cachedir}/${::tomcat::source_real}"],
  }

  exec { "create_target_tomcat-${::tomcat::install::mod_name}":
    cwd     => '/',
    command => "mkdir -p ${::tomcat::deploymentdir_real}",
    creates => $::tomcat::deploymentdir_real,
    require => Exec["extract_tomcat-${::tomcat::install::mod_name}"],
  }

  exec { "move_tomcat-${::tomcat::install::mod_name}":
    cwd     => $::tomcat::install::cachedir,
    command => "cp -r extracted/apache-tomcat*/* ${::tomcat::deploymentdir_real} && chown -R ${::tomcat::user_real}:${::tomcat::user_real} ${::tomcat::deploymentdir_real}",
    creates => "${::tomcat::deploymentdir_real}/lib/catalina.jar",
    require => Exec["create_target_tomcat-${::tomcat::install::mod_name}"],
  }

  if ($::tomcat::default_webapp_docs_real == 'absent') {
    file { "${::tomcat::deploymentdir_real}/webapps/docs":
      ensure  => absent,
      recurse => true,
      force   => true,
      require => Exec["move_tomcat-${::tomcat::install::mod_name}"],
    }
  }

  if ($::tomcat::default_webapp_examples_real == 'absent') {
    file { "${::tomcat::deploymentdir_real}/webapps/examples":
      ensure  => absent,
      recurse => true,
      force   => true,
      require => Exec["move_tomcat-${::tomcat::install::mod_name}"],
    }
  }

  if ($::tomcat::default_webapp_hostmanager_real == 'absent') {
    file { "${::tomcat::deploymentdir_real}/webapps/host-manager":
      ensure  => absent,
      recurse => true,
      force   => true,
      require => Exec["move_tomcat-${::tomcat::install::mod_name}"],
    }
  }

  if ($::tomcat::default_webapp_manager_real == 'absent') {
    file { "${::tomcat::deploymentdir_real}/webapps/manager":
      ensure  => absent,
      recurse => true,
      force   => true,
      require => Exec["move_tomcat-${::tomcat::install::mod_name}"],
    }
  }

  if ($::tomcat::default_webapp_root_real == 'absent') {
    file { "${::tomcat::deploymentdir_real}/webapps/ROOT":
      ensure  => absent,
      recurse => true,
      force   => true,
      require => Exec["move_tomcat-${::tomcat::install::mod_name}"],
    }
  }
}
