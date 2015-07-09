require 'fencing/config'
require 'fencing/facter_adapter'
require 'fencing/classifier'
require 'fencing/node_resolver'
require 'json'

module OS
	module Puppet
		module Fencing

			class FencingRunner

				def initialize(config_location, nodes_location)
					config_json = JSON.parse(File.read(config_location))
					config = OS::Puppet::Fencing::Config.new(config_json)
					facter_adapter = OS::Puppet::Fencing::FacterAdapter.new
					@classifier = OS::Puppet::Fencing::Classifier.new(config, facter_adapter)
					@resolver = OS::Puppet::Fencing::NodeResolver.new(nodes_location)
				end

				def lookup(host_name)
					node_file_name = @classifier.resolve_node(host_name)
					node_definition = @resolver.resolve(node_file_name)
				end

			end

		end
	end
end
