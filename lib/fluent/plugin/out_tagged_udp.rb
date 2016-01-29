module Fluent
  class TaggedUdpOutput < Output

    # First, register the plugin. NAME is the name of this plugin
    # and identifies the plugin in the configuration file.
    Fluent::Plugin.register_output('tagged_udp', self)

    config_param :host, :string, :default => '127.0.0.1'
    config_param :port, :integer, :default => 1883
    config_param :tag_sep, :string, :default => "\t"
    config_param :time_key, :string, :default => 'time'
    config_param :time_format, :string, :default => nil
    config_param :send_time, :bool, :default => false
    config_param :send_time_key, :string, :default => "send_time"

    require 'socket'

    # This method is called before starting.
    # 'conf' is a Hash that includes configuration parameters.
    # If the configuration is invalid, raise Fluent::ConfigError.
    def configure(conf)
      super
      @socket = UDPSocket.new
    end

    def format_time(time)
      case @time_format
      when nil then
        # default format is integer value
        time
      when "iso8601" then
        # iso8601 format
        Time.at(time).iso8601
      else
        # specified strftime format
        Time.at(time).strftime(@time_format)
      end
    end

    def timestamp_hash(time)
      if @time_key.nil?
        {}
      else
        {@time_key => format_time(time)}
      end
    end

    def add_send_time(record)
      if @send_time
        # send_time is recorded in ms
        record.merge({@send_time_key => Time.now.instance_eval { self.to_i * 1000 + (usec/1000) }})
      else
        record
      end
    end

    def emit(tag, es, chain)
      begin
        es.each {|time,record|
          $log.debug "#{tag}, #{format_time(time)}, #{add_send_time(record)}"
          @socket.send(
            # tag is inserted into the head of the message
            "#{tag}#{@tag_sep}#{add_send_time(record).merge(timestamp_hash(time)).to_json}",
            0, @host, @port
          )
        }
        $log.flush
        chain.next
      rescue StandardError => e
        $log.debug "#{e.class}: #{e.message}"
      end
    end
  end
end
