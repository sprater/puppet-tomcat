
define tomcat::setup (
  $source         = undef,
  $deploymentdir  = undef,
  $user           = undef,
  $serverxml      = undef,
  $webxml         = undef,
  $init_script    = undef,
  $ensure         = 'running',
  $enable         = true,
  $defaultwebapps = true,
  $cachedir       = "/var/lib/puppet/working-tomcat-${name}") {
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

  if ($defaultwebapps == false) {
    file { [
      "${deploymentdir}/webapps/docs",
      "${deploymentdir}/webapps/examples",
      "${deploymentdir}/webapps/host-manager",
      "${deploymentdir}/webapps/manager",
      "${deploymentdir}/webapps/ROOT"]:
      ensure  => absent,
      recurse => true,
      force   => true,
    }
  }
}
