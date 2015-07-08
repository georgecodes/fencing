require 'rspec'
require 'spec_helper'

RSpec.describe "Facter" do

	it "retrieves a fact from the puppet directory" do
		node_dir = File.join(__dir__, 'fixtures/nodes')
		
		facter_adapter = OS::Puppet::Enc::FacterAdapter.new(node_dir)

		expect(facter_adapter.lookup('node1', 'node_ready')).to eq('true')

	end
	
end