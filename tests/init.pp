tomcat::setup { 'tomcat7':
  source        => "apache-ant-1.9.0-bin.tar.gz",
  deploymentdir => "/home/jude/tomcat7",
  user          => "jude",
  serverxml     => "test",
  webxml        => "test",
  init_script   => "test",
  ensure        => "running"
}