# spec/classes/tomcat_spec.pp

require 'spec_helper'

describe 'tomcat::install', :type => :define do

  let(:title) { 'test_default' }
  let :pre_condition do
      'include tomcat'
  end

  it {
    should contain_class('tomcat')
  }

  # Test source
  context "With no source specified" do
    it {
      should contain_file('/var/lib/puppet/working-tomcat-tomcat/apache-tomcat-7.0.50.tar.gz').with( { 
        'source' => 'puppet:///modules/tomcat/apache-tomcat-7.0.50.tar.gz' } )
    }
  end

  context "With source specified" do
    let :params do
      {
        :source => 'testtomcatsource.tar.gz'
      }
    end
    it {
      should contain_file('/var/lib/puppet/working-tomcat-tomcat/testtomcatsource.tar.gz').with( { 
        'source' => 'puppet:///modules/tomcat/testtomcatsource.tar.gz' } )
    }
  end

  # Test tomcat home
  context "With no tomcat deploy directory specified" do
    it {
      should contain_exec('create_target_tomcat-tomcat').with( {
        'creates'    => '/opt/tomcat7',
      } )
    }

    it {
      should contain_exec('move_tomcat-tomcat').with( {
        'creates'    => '/opt/tomcat7/lib/catalina.jar',
      } )
    }
  end

  context "With tomcat deploy directory specified" do
    let :params do
      {
        :deploymentdir => '/usr/local/tomcat7',
      }
    end
    it {
      should contain_exec('create_target_tomcat-tomcat').with( {
        'creates'    => '/usr/local/tomcat7',
      } )
    }

    it {
      should contain_exec('move_tomcat-tomcat').with( {
        'creates'    => '/usr/local/tomcat7/lib/catalina.jar',
      } )
    }
  end

  # Test user
  context "With no user or group specified" do
    it {
      should contain_exec('move_tomcat-tomcat').with( {
        'command'     => 'cp -r extracted/apache-tomcat*/* /opt/tomcat7 && chown -R tomcat:tomcat /opt/tomcat7',
      } )
    }
  end

  context "With user specified" do
    let :params do
      {
        :user         => 'fred',
      }
    end
    it {
      should contain_exec('move_tomcat-tomcat').with( {
        'command'     => 'cp -r extracted/apache-tomcat*/* /opt/tomcat7 && chown -R fred:tomcat /opt/tomcat7',
      } )
    }
  end

  context "With group specified" do
    let :params do
      {
        :group         => 'barney',
      }
    end
    it {
      should contain_exec('move_tomcat-tomcat').with( {
        'command'     => 'cp -r extracted/apache-tomcat*/* /opt/tomcat7 && chown -R tomcat:barney /opt/tomcat7',
      } )
    }
  end

  context "With user and group specified" do
    let :params do
      {
        :user         => 'fred',
        :group         => 'barney',
      }
    end
    it {
      should contain_exec('move_tomcat-tomcat').with( {
        'command'     => 'cp -r extracted/apache-tomcat*/* /opt/tomcat7 && chown -R fred:barney /opt/tomcat7',
      } )
    }
  end

  context "With user and deployment directory specified" do
    let :params do
      {
        :user   => 'fred',
        :deploymentdir  => '/usr/local/tomcat7',
      }
    end
    it {
      should contain_exec('move_tomcat-tomcat').with( {
        'command'     => 'cp -r extracted/apache-tomcat*/* /usr/local/tomcat7 && chown -R fred:tomcat /usr/local/tomcat7',
      } )
    }
  end

  # Test presence of default webapps docs
  context "With no default webapps docs presence specified" do
    it {
      should_not contain_file('/opt/tomcat7/webapps/docs')
    }
  end
  context "With default webapps docs set to 'absent'" do
    let :params do
      {
        :default_webapp_docs   => 'absent',
      }
    end
    it {
      should contain_file('/opt/tomcat7/webapps/docs').with( {
        'ensure'  => 'absent',
        'recurse' => true,
        'force'   => true,
      } )
    }
  end

  # Test presence of default webapps examples
  context "With no default webapps examples presence specified" do
    it {
      should_not contain_file('/opt/tomcat7/webapps/examples')
    }
  end
  context "With default webapps examples set to 'absent'" do
    let :params do
      {
        :default_webapp_examples   => 'absent',
      }
    end
    it {
      should contain_file('/opt/tomcat7/webapps/examples').with( {
        'ensure'  => 'absent',
        'recurse' => true,
        'force'   => true,
      } )
    }
  end

  # Test presence of default webapps host-manager
  context "With no default webapps host-manager presence specified" do
    it {
      should_not contain_file('/opt/tomcat7/webapps/host-manager')
    }
  end
  context "With default webapps host-manager set to 'absent'" do
    let :params do
      {
        :default_webapp_hostmanager   => 'absent',
      }
    end
    it {
      should contain_file('/opt/tomcat7/webapps/host-manager').with( {
        'ensure'  => 'absent',
        'recurse' => true,
        'force'   => true,
      } )
    }
  end

  # Test presence of default webapps manager
  context "With no default webapps manager presence specified" do
    it {
      should_not contain_file('/opt/tomcat7/webapps/manager')
    }
  end
  context "With default webapps manager set to 'absent'" do
    let :params do
      {
        :default_webapp_manager   => 'absent',
      }
    end
    it {
      should contain_file('/opt/tomcat7/webapps/manager').with( {
        'ensure'  => 'absent',
        'recurse' => true,
        'force'   => true,
      } )
    }
  end

  # Test presence of default webapps ROOT
  context "With no default webapps ROOT presence specified" do
    it {
      should_not contain_file('/opt/tomcat7/webapps/ROOT')
    }
  end
  context "With default webapps ROOT set to 'absent'" do
    let :params do
      {
        :default_webapp_root   => 'absent',
      }
    end
    it {
      should contain_file('/opt/tomcat7/webapps/ROOT').with( {
        'ensure'  => 'absent',
        'recurse' => true,
        'force'   => true,
      } )
    }
  end

end
