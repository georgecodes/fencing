require 'logger'

module OS
  module Puppet
    module Fencing

      class Log

        @@log = Logger.new(File.open('/etc/puppet/enc/enc-daemon.log', File::WRONLY | File::APPEND | File::CREAT))
        @@log.level = Logger::DEBUG
        @@log.debug "Started Fencing"

        def self.log(message)
          @@log.debug message
        end

      end

    end
  end
end