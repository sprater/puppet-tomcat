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
#  unpacked.  Default is "
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

class tomcat::install {

  include tomcat

  $cachedir = "/var/lib/puppet/working-tomcat-${name}"

  if ($caller_module_name == undef) {
    $mod_name = $module_name
  } else {
    $mod_name = $caller_module_name
  }

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

  file { "${cachedir}/${source}":
    source  => "puppet:///modules/${mod_name}/${source}",
    require => File[$cachedir],
  }

  exec { "extract_tomcat-${name}":
    cwd     => $cachedir,
    command => "mkdir extracted; tar -C extracted -xzf ${source} && touch .tomcat_extracted",
    creates => "${cachedir}/.tomcat_extracted",
    require => File["${cachedir}/${source}"],
  }

  exec { "create_target_tomcat-${name}":
    cwd     => '/',
    command => "mkdir -p ${deploymentdir}",
    creates => $deploymentdir,
    require => Exec["extract_tomcat-${name}"],
  }

  exec { "move_tomcat-${name}":
    cwd     => $cachedir,
    command => "cp -r extracted/apache-tomcat*/* ${deploymentdir} && chown -R ${user}:${user} ${deploymentdir}",
    creates => "${deploymentdir}/lib/catalina.jar",
    require => Exec["create_target_tomcat-${name}"],
  }

  if ($default_webapp_docs == 'absent') {
    file { "${deploymentdir}/webapps/docs":
      ensure  => absent,
      recurse => true,
      force   => true,
      require => Exec["move_tomcat-${name}"],
    }
  }

  if ($default_webapp_examples == 'absent') {
    file { "${deploymentdir}/webapps/examples":
      ensure  => absent,
      recurse => true,
      force   => true,
      require => Exec["move_tomcat-${name}"],
    }
  }

  if ($default_webapp_hostmanager == 'absent') {
    file { "${deploymentdir}/webapps/host-manager":
      ensure  => absent,
      recurse => true,
      force   => true,
      require => Exec["move_tomcat-${name}"],
    }
  }

  if ($default_webapp_manager == 'absent') {
    file { "${deploymentdir}/webapps/manager":
      ensure  => absent,
      recurse => true,
      force   => true,
      require => Exec["move_tomcat-${name}"],
    }
  }

  if ($default_webapp_root == 'absent') {
    file { "${deploymentdir}/webapps/ROOT":
      ensure  => absent,
      recurse => true,
      force   => true,
      require => Exec["move_tomcat-${name}"],
    }
  }
}
