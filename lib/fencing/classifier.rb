require 'fencing/log'

module OS
  module Puppet
    module Fencing

    	class Classifier

    		def initialize(config, facter_adapter)
    			@config = config
    			@facter = facter_adapter
    		end

    		def resolve_node(host_name)
                Log.log("Looking up #{host_name}")
    			node_config = @config.match_node(host_name)
    			assert_blocked(host_name, node_config.blocker)
    			node_config.node
    		end

    		def assert_blocked(host_name, blocker)
                return if !blocker
    			allowed_host = blocker.blocking_host_name
                Log.log("blocker not blocking #{allowed_host}")
    			return if host_name.start_with?(allowed_host)
    			fact_name = blocker.fact
    			fact_value = @facter.lookup(allowed_host, fact_name)
                Log.log("Fact #{fact_name} on node #{allowed_host} has value #{fact_value}: expecting #{blocker.expected_value}")
    			raise "cannot release #{host_name}" unless fact_value == blocker.expected_value
                Log.log("Fine - releasing node definition for #{host_name}")
    		end

    	end

  	end
  end
end