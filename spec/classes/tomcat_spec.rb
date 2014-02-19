# spec/classes/tomcat_spec.pp

require 'spec_helper'

describe 'tomcat' do

  it 'includes stdlib' do
    should contain_class('stdlib')
  end

  it { should contain_class('tomcat') }
  it { should contain_class('tomcat::params') }

end
