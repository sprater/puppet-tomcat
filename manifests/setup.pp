
define tomcat::setup (
  $source        = undef,
  $deploymentdir = undef,
  $user          = undef,
  $serverxml     = undef,
  $webxml        = undef,
  $init_script   = undef,
  $ensure        = 'running',
  $enable        = true,
  $default_webapp_docs        = "present",
  $default_webapp_examples    = "present",
  $default_webapp_hostmanager = "present",
  $default_webapp_manager     = "present",
  $default_webapp_root        = "present",
  $cachedir      = "/var/lib/puppet/working-tomcat-${name}") {
  # we support only Debian and RedHat
  case $::osfamily {
    Debian  : { $supported = true }
    RedHat  : { $supported = true }
    default : { fail("The ${module_name} module is not supported on ${::osfamily} based systems") }
  }

  # validate parameters
  if ($source == undef) {
    fail('source parameter must be set')
  }

  if ($deploymentdir == undef) {
    fail('deploymentdir parameter must be set')
  }

  if ($user == undef) {
    fail('user parameter must be set')
  }

  if ($serverxml == undef) {
    fail('serverxml parameter must be set')
  }

  if ($webxml == undef) {
    fail('webxml parameter must be set')
  }

  if ($init_script == undef) {
    fail('init_script parameter must be set')
  }

  if !($default_webapp_docs in ['present', 'absent']) {
    fail('default_webapp_docs parameter must be either present or absent')
  }

  if !($default_webapp_examples in ['present', 'absent']) {
    fail('default_webapp_examples parameter must be either present or absent')
  }

  if !($default_webapp_hostmanager in ['present', 'absent']) {
    fail('default_webapp_hostmanager parameter must be either present or absent')
  }

  if !($default_webapp_manager in ['present', 'absent']) {
    fail('default_webapp_manager parameter must be either present or absent')
  }

  if !($default_webapp_root in ['present', 'absent']) {
    fail('default_webapp_root parameter must be either present or absent')
  }

  if !($ensure in ['running', 'stopped']) {
    fail('ensure parameter must be running or stopped')
  }


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
    mode   => '644',
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

  if ($default_webapp_docs == "absent") {
    file { "${deploymentdir}/webapps/docs":
      ensure  => absent,
      recurse => true,
      force   => true,
      require => Exec["move_tomcat-${name}"],
    }
  }

  if ($default_webapp_examples == "absent") {
    file { "${deploymentdir}/webapps/examples":
      ensure  => absent,
      recurse => true,
      force   => true,
      require => Exec["move_tomcat-${name}"],
    }
  }

  if ($default_webapp_hostmanager == "absent") {
    file { "${deploymentdir}/webapps/host-manager":
      ensure  => absent,
      recurse => true,
      force   => true,
      require => Exec["move_tomcat-${name}"],
    }
  }

  if ($default_webapp_manager == "absent") {
    file { "${deploymentdir}/webapps/manager":
      ensure  => absent,
      recurse => true,
      force   => true,
      require => Exec["move_tomcat-${name}"],
    }
  }

  if ($default_webapp_root == "absent") {
    file { "${deploymentdir}/webapps/ROOT":
      ensure  => absent,
      recurse => true,
      force   => true,
      require => Exec["move_tomcat-${name}"],
    }
  }
}
