module OS
  module Puppet
    module Enc

    	class Classifier

    		def initialize(config, facter_adapter)
    			@config = config
    			@facter = facter_adapter
    		end

    		def resolve_node(host_name)
    			hostname_config = @config.hosts
    			hostname_config.each do | k, v |
    				return extract_node_name(v) if(host_name.start_with?(k))
    			end
    			raise "Could not find configuration for host #{host_name}"
    		end

    		def extract_node_name(host_config)
    			if(host_config.class == String) 
    				assert_globally_blocked(host_config)
    				return host_config
    			end
    		end

    		def assert_globally_blocked(host_name)
    			global_blocker = @config.global_blocker
    			globally_allowed_host = global_blocker.host_name
    			return if host_name.start_with?(globally_allowed_host)
    			fact_name = global_blocker.fact
    			fact_value = @facter.lookup(fact_name)
    			raise "cannot release #{host_name}" unless fact_value == global_blocker.expected_value
    		end

    	end

  	end
  end
end