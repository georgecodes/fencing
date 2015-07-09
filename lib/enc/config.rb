module OS
  module Puppet
    module Enc

    	class Config

            attr_reader :nodes

    		def initialize(config_hash)
    			@config = config_hash
                global_blocker_config = config_hash['blocker']
                @global_blocker = Blocker.new(global_blocker_config) if global_blocker_config
                @nodes = []
                
                config_hash['hosts'].each do | host_prefix, conf|
                    node_name = conf
                    blocker = @global_blocker
                    if(conf.class == Hash)
                        node_name = conf['node_name']
                        blocker_conf = conf['blocker'] 
                        blocker = blocker_conf ? Blocker.new(conf['blocker']) : global_blocker
                    end
                    nodes << Node.new(host_prefix, node_name, blocker)
                end
                
    		end

            def match_node(host_name)
                nodes.each do | node |
                    return node if host_name.start_with?(node.host_prefix)
                end
                raise "Could not find configuration for host #{host_name}"
            end

            def global_blocker
                @global_blocker
            end

    	end

        class Node

            attr_reader :host_prefix, :node, :blocker

            def initialize(host_prefix, node_file_name, blocker)
                @host_prefix = host_prefix
                @node = node_file_name
                @blocker = blocker
            end

        end


        class Blocker

            attr_reader :blocking_host_name, :fact, :expected_value

            def initialize(hash)
                @blocking_host_name = hash['blocking_host_name']
                @fact = hash['fact']
                @expected_value = hash['expected_value']
            end

        end

  	end
  end
end