# Fencing

Fencing is a Puppet external node classifier which will hold back node definitions until Puppet Facts meet required conditions. This is useful if you need to orchestrate nodes.

## Motivation

When configuring an estate, we had a requirement to bring up certain services before others. This is not really supported by Puppet, and is mitigated is a number of ways, such as using MCollective or Ansible to orchestrate the nodes. We already had an ENC in place, and it seemed a fairly simple move to extend that to only release node definitions when certain conditions were met.

## How it works

The Puppetmaster locally stores all Facts from every node it manages. If we define a custom fact on a node to say "I'm ready", then the ENC can look at the state of this fact and make a decision on whether to release a node definition to the Puppet master. 

## Use

Fencing is a Ruby Gem. You can install it with

    $ gem install fencing

To configure your Puppetmaster to use it, your Puppetmaster's puppet.conf needs an entry like this

    [master]
      node_terminus = exec
      external_nodes = "/usr/bin/fencing <path_to_conf_file> <path_to_node_definitions>"

Both provided paths must be absolute. The node definitions are, of course, the yamls that will be released to Puppet.


The configuration file is JSON, and it looks like this:

    {
			"hosts" : {
				"node1" : "node1",
				"node2" : "node2",
				"node3" : {
					"node_name" : "node3"
				},
				"node4" : {
					"node_name" : "node4",
					"blocker" : {
						"blocking_host_name" : "node3",
						"fact" : "node3_ready",
						"expected_value" : "true"
					}
				}
			},
			"blocker" : {
				"blocking_host_name" : "node1",
				"fact" : "node1_ready",
				"expected_value" : "true"
			}
		}

The hosts element is mandatory. In the above example, any hostname passed to the ENC which starts with *node1* will be passed back *node1.yaml*, providing the global blocker is satisfied. This is configured by the blocker element, and in this case, it says that node defintions will not be released until the host whose name starts with node1 reports that the Puppet Fact node1_ready returns true. Obviously, node1 cannot block itself or your estate would never be configured, so the node1 defintion will be released regardless.

Also in the above example, node4 is not dependent on the global blocker, but instead it blocks until node3 reports that the Fact node3_ready is true. Anything which has its own inline blocker configured currently ignores the global blocker.