require 'yaml'
require 'puppet'

module OS
	module Puppet
		module Fencing

			class FacterAdapter

				def initialize(puppet_nodes_dir = '/var/lib/puppet/yaml/node')
					@node_dir = puppet_nodes_dir
				end

				def lookup(node_name, fact_name)
					node_def = find_node_def(node_name)
					node = YAML.load_file(node_def)
					fact_list = node.facts.to_data_hash
					fact_result = fact_list['values'][fact_name]
					raise "Fact #{fact_name} not found on node #{node_name}" if fact_result == nil
					fact_result
	  		end

	  		def find_node_def(node_name)
	  			Dir.foreach(@node_dir) do | file |
	  				return File.join(@node_dir, file) if file.start_with?(node_name)
	  			end
	  			raise "Cannot find node #{node_name}"
	  		end

			end

		end
	end
end