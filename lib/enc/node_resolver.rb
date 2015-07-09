require 'yaml'

module OS
	module Puppet
		module Enc

			class NodeResolver

				def initialize(nodes_location)
					@location = nodes_location
				end

				def resolve(file_name)
					File.read(File.join(@location, "#{file_name}.yaml"))
				end

			end

		end
	end
end