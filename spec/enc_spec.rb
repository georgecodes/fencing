require 'rspec'
require 'spec_helper'

RSpec.describe 'configured ENC' do

	before(:each) do
		config_hash = {
			:hosts => {
				'node1' => 'node1',
				'node2' => 'node2',
				'node3' => {
					'node_name' => 'node3'
				},
				'node4' => {
					'node_name' => 'node4',
					'blocker' => {
						'blocking_host_name' => 'node3',
						'fact' => 'node3_ready',
						'expected_value' => 'true'
					}
				}
			},
			:blocker => {
				'blocking_host_name' => 'node1',
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

	it "does not block the node that is the global blocker" do

		host_name = 'node1.os.uk'
	 	allow(@facter).to receive(:lookup).with('node1', 'node1_ready') { 'false' }

	 	expect(@enc.resolve_node(host_name)).to eq('node1')

	end

	it "returns the node name for a simple node" do

		host_name = 'node2.os.uk'
		allow(@facter).to receive(:lookup).with('node1', 'node1_ready') { 'true' }

		expect(@enc.resolve_node(host_name)).to eq('node2')

	end

	it "raises an error if the node is blocked by the global blocker" do

	 	host_name = 'node2.os.uk'
	 	allow(@facter).to receive(:lookup).with('node1', 'node1_ready') { 'false' }

	 	expect { @enc.resolve_node(host_name)}.to raise_error(RuntimeError)

	end

	it "returns the node name for a configured node" do

		host_name = 'node3.os.uk'
	 	allow(@facter).to receive(:lookup).with('node1', 'node1_ready') { 'true' }

	 	expect(@enc.resolve_node(host_name)).to eq('node3')

	 end

	 it "ignores the global blocker if a node has its own blocker" do 
	
		host_name = 'node4.os.uk'
		allow(@facter).to receive(:lookup).with('node1', 'node1_ready') { 'false' }
	 	allow(@facter).to receive(:lookup).with('node3', 'node3_ready') { 'true' }

	 	expect(@enc.resolve_node(host_name)).to eq('node4')

	 end

	 it "will not release if the nodes blocker does not allow it" do
			
		host_name = 'node4.os.uk'
		allow(@facter).to receive(:lookup).with('node1', 'node1_ready') { 'false' }
	 	allow(@facter).to receive(:lookup).with('node3', 'node3_ready') { 'false' }

	 	expect {@enc.resolve_node(host_name)}.to raise_error(RuntimeError)

	 end






































end