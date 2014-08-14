require_relative 'spec_helper'

describe 'nginx' do
  it 'running' do
    expect(process 'nginx').to be_running
  end

  it 'listen on port 80' do
    expect(port 80).to be_listening
  end
end
