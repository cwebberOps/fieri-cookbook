require_relative 'spec_helper'

describe 'fieri' do
  it 'creates a unicorn socket' do
    expect(file '/tmp/.fieri.sock.0').to be_socket
  end

  describe file('/srv/fieri/current/.env') do
    it { should be_linked_to '/srv/fieri/shared/.env.production' }
  end

  describe file('/srv/fieri/current/log') do
    it { should be_linked_to '/srv/fieri/shared/log' }
  end
end
