tomcat::setup { 'tomcat7':
  source        => "apache-tomcat-7.0.39.tar.gz",
  deploymentdir => "/root/tomcat7",
  user          => "root",
  serverxml     => "test",
  webxml        => "test",
  init_script   => "test",
  ensure        => "running"
}