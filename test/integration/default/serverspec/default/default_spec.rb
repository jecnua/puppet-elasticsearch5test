# frozen_string_literal: true
require 'spec_helper'

describe file('/etc/hosts') do
  it { should contain 'localhost' }
end

describe command('curl localhost:9200/_cat/nodes') do
  its(:stdout) { should match(/mdi/) }
end
