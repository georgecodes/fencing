module OS
  module Puppet
    module Enc

    	class Config

    		def initialize(config_hash)
    			@config = config_hash
                @global_blocker = Blocker.new(config_hash[:blocker])
    		end

            def hosts
                @config[:hosts]
            end

            def global_blocker
                @global_blocker
            end

    	end

        class Blocker

            attr_reader :host_name, :fact, :expected_value

            def initialize(hash)
                @host_name = hash['host_name']
                @fact = hash['fact']
                @expected_value = hash['expected_value']
            end

        end

  	end
  end
end