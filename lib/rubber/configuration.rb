require 'logger'
require 'rubber/environment'
require 'rubber/instance'
require 'rubber/generator'

module Rubber
  module Configuration

    @@configurations = {}

    def self.get_configuration(env=nil, root=nil)
      key = "#{env}-#{root}"
      @@configurations[key] ||= ConfigHolder.new(env, root)
    end

    def self.rubber_env
      raise "This convenience method needs Rubber.env to be set" unless Rubber.env
      cfg = Rubber::Configuration.get_configuration(Rubber.env)
      host = cfg.environment.current_host
      roles = cfg.instance[host].role_names rescue nil
      cfg.environment.bind(roles, host)
    end

    def self.rubber_instances
      raise "This convenience method needs Rubber.env to be set" unless Rubber.env
      Rubber::Configuration.get_configuration(Rubber.env).instance
    end

    class ConfigHolder
      def initialize(env=nil, root=nil)
        root = "#{Rubber.root}/config/rubber" unless root
        instance_cfg =  "#{root}/instance" + (env ? "-#{env}.yml" : ".yml")
        @environment = Environment.new("#{root}")
        @instance = Instance.new(instance_cfg)
      end

      def environment
        @environment
      end

      def instance
        @instance
      end
    end

  end
end
