module Fluent
  class taggedUdpInput < Input

    # First, register the plugin. NAME is the name of this plugin
    # and identifies the plugin in the configuration file.
    Fluent::Plugin.register_input('tagged_udp', self)

    config_param :bind, :string, :default => '127.0.0.1'
    config_param :port, :integer, :default => 1883
    config_param :tag_sep, :string, :default => "\t"
    config_param :format, :string, :default => 'json'

    require 'socket'

    # Define `router` method of v0.12 to support v0.10 or earlier
    unless method_defined?(:router)
      define_method("router") { Fluent::Engine }
    end

    # This method is called before starting.
    # 'conf' is a Hash that includes configuration parameters.
    # If the configuration is invalid, raise Fluent::ConfigError.
    def configure(conf)
      super

      # You can also refer raw parameter via conf[name].
      @bind ||= conf['bind']
      @port ||= conf['port']
      @tag_sep ||= conf['tag_sep']
      configure_parser(conf)
    end

    def configure_parser(conf)
      @parser = Plugin.new_parser(conf['format'])
      @parser.configure(conf)
    end

    def parse(message)
      @parser.parse(message) do |time, record|
        if time.nil?
          $log.debug "Since time_key field is nil, Fluent::Engine.now is used."
          time = Fluent::Engine.now
        end
        return [time, record]
      end
    end

    def start
      $log.debug "start udp server #{@bind}"

      @thread = Thread.new(Thread.current) do |parent|
        begin
          Socket.udp_server_loop(@bind, @port) do |msg, msg_src|
            $log.debug("Received #{msg}")
            tag, message = msg.split(@tag_sep)
            time, record = parse(message)
            $log.debug "#{tag}, #{time}, #{record}"
            router.emit(tag, time, record)
          end
        rescue StandardError => e
          parent.raise(e)
        end
      end
    end

    def shutdown
      @thread.kill
    end
  end
end
