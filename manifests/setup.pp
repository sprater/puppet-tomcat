
define tomcat::setup (
  $source        = undef,
  $deploymentdir = undef,
  $user          = undef,
  $serverxml     = undef,
  $webxml        = undef,
  $init_script   = undef,
  $ensure        = 'running',
  $enable        = true,
  $default_webapp_docs        = present,
  $default_webapp_examples    = present,
  $default_webapp_hostmanager = present,
  $default_webapp_manager     = present,
  $default_webapp_root        = present,
  $cachedir      = "/var/lib/puppet/working-tomcat-${name}") {
  # To do:
  # Validate input for $default_webapp*
  # working directory to untar tomcat
  file { $cachedir:
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '644',
  }

  # resource defaults for Exec
  Exec {
    path => ['/sbin', '/bin', '/usr/sbin', '/usr/bin'], }

  file { "${cachedir}/${source}":
    source  => "puppet:///modules/${caller_module_name}/${source}",
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

  if ($default_webapp_docs == absent) {
    file { "${deploymentdir}/webapps/docs":
      ensure  => absent,
      recurse => true,
      force   => true,
      require => Exec["move_tomcat-${name}"],
    }
  }

  if ($default_webapp_examples == absent) {
    file { "${deploymentdir}/webapps/examples":
      ensure  => absent,
      recurse => true,
      force   => true,
      require => Exec["move_tomcat-${name}"],
    }
  }

  if ($default_webapp_hostmanager == absent) {
    file { "${deploymentdir}/webapps/host-manager":
      ensure  => absent,
      recurse => true,
      force   => true,
      require => Exec["move_tomcat-${name}"],
    }
  }

  if ($default_webapp_manager == absent) {
    file { "${deploymentdir}/webapps/manager":
      ensure  => absent,
      recurse => true,
      force   => true,
      require => Exec["move_tomcat-${name}"],
    }
  }

  if ($default_webapp_root == absent) {
    file { "${deploymentdir}/webapps/ROOT":
      ensure  => absent,
      recurse => true,
      force   => true,
      require => Exec["move_tomcat-${name}"],
    }
  }
}
