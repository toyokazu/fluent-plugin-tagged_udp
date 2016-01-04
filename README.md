# Fluent::Plugin::json_udp

Fluent plugin for JSON UDP Input/Output.
This plugin is a special plugin to submit a message as a UDP packet. While fluentd's default UDP Input plugin supports to add a tag to the received message, this plugin support to add tag information as an attribute of JSON message.

## Installation

Add this line to your application's Gemfile:

    gem 'fluent-plugin-json-udp'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fluent-plugin-json-udp


## Usage

fluent-plugin-json-udp provides UDP input/output function for fluentd.

Input plugin can be used via source directive.

```
<source **>
  type json_udp
  bind 127.0.0.1
  port 20001
</source>

```

Output Plugin can be used via match directive.

```

<match **>
  type json_udp
  host 127.0.0.1
  port 20001
</match>

```

## Contributing

1. Fork it ( http://github.com/toyokazu/fluent-plugin-udp/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
