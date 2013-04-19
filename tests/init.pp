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