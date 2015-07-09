require 'enc/config'
require 'enc/facter_adapter'
require 'enc/classifier'
require 'enc/node_resolver'
require 'json'

module OS
	module Puppet
		module Enc

			class EncRunner

				def initialize(config_location, nodes_location)
					config_json = JSON.parse(File.read(config_location))
					config = OS::Puppet::Enc::Config.new(config_json)
					facter_adapter = OS::Puppet::Enc::FacterAdapter.new
					@enc = OS::Puppet::Enc::Classifier.new(config, facter_adapter)
					@resolver = OS::Puppet::Enc::NodeResolver.new(nodes_location)
				end

				def lookup(host_name)
					node_file_name = @enc.resolve_node(host_name)
					node_definition = @resolver.resolve(node_file_name)
				end

			end

		end
	end
end
