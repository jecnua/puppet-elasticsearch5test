# frozen_string_literal: true
require 'spec_helper'

describe file('/etc/hosts') do
  it { should contain 'localhost' }
end

describe command('curl localhost:9200/_cat/nodes') do
  its(:stdout) { should match(/mdi/) }
end

describe command('curl localhost:9200/_cat/plugins') do
  its(:stdout) { should match(/discovery-ec2/) }
  its(:stdout) { should match(/repository-s3/) }
  its(:stdout) { should match(/x-pack/) }
  its(:stdout) { should match(/prometheus-exporter/) }
end

describe command('curl localhost:9200/') do
  its(:stdout) { should match(/5.2.2/) }
end
