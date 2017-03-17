# frozen_string_literal: true
require 'spec_helper'

describe file('/etc/hosts') do
  it { should contain 'localhost' }
end
