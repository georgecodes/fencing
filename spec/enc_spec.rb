require 'rspec'
require_relative '../lib/config'
require_relative '../lib/enc'

RSpec.describe 'configured ENC' do

	before(:all) do
		config_hash = {
			:hosts => {
				'node1' => 'node1',
				'node2' => 'node2',
			},
			:blocker => {
				'host_name' => 'node1',
				'fact' => 'node1_ready',
				'expected_value' => 'true'
			}
		}
		config = OS::Puppet::Enc::Config.new(config_hash)
		@facter = double('facter')
		@enc = OS::Puppet::Enc::Classifier.new(config, @facter)
	end

	it "raises an error if the node isn't found" do

		host_name = 'nonexistent.os.uk'

		expect { @enc.resolve_node(host_name)}.to raise_error(RuntimeError)

	end

	it "returns the node name for a simple node" do

		host_name = 'node1.os.uk'

		expect(@enc.resolve_node(host_name)).to eq('node1')

	end

	it "raises an error if the node is blocked by the global blocker" do

	 	host_name = 'node2.os.uk'
	 	allow(@facter).to receive(:lookup).with('node1_ready') { 'false' }

	 	expect { @enc.resolve_node(host_name)}.to raise_error(RuntimeError)

	end


	
end