require_relative 'spec_helper'

describe 'fieri' do
  it 'creates a unicorn socket' do
    expect(file '/tmp/.fieri.sock.0').to be_socket
  end
end
