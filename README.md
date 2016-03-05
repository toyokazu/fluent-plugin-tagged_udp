# Fluent::Plugin::tagged_udp

Fluent plugin for tagged UDP Input/Output.
Fluentd checks the destination status by UDP packets and messages are transferred via TCP connection. While it is useful for the transfer using stable connection, for mobile environment, it is not suitable in some cases. Supporting UDP transfer provides us flexibility to implement sensor networks. fluent-plugin-tagged_udp is a special plugin to submit a message as a UDP packet. While fluentd's default UDP Input plugin supports to add a tag to the received message statically by configuration, it does not support to extract a tag from the received message. This plugin supports to add tag name into UDP packet which is separated by a special character and also supports to extract tag name from the UDP packet. Encryption/Decription is not supported in this plugin but [fluent-plugin-jwt-filter](https://github.com/toyokazu/fluent-plugin-jwt-filter) can be used to encrypt/decrypt messages using JSON Web Token technology.


## Installation

Add this line to your application's Gemfile:

    gem 'fluent-plugin-tagged_udp'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fluent-plugin-tagged_udp


## Usage

fluent-plugin-tagged_udp provides UDP input/output function for fluentd.

Input plugin can be used via source directive.

```
<source **>
  type tagged_udp
  bind 127.0.0.1
  port 20001
  format json # required
</source>

```

Optional parameters are as follows:

- tag_sep: separator of tag name. default is "\t"
- recv_time: Add receive time to message in millisecond (ms) as integer for debug and performance/delay analysis
- recv_time_key: An attribute of recv_time


Output Plugin can be used via match directive.

```

<match **>
  type tagged_udp
  host 127.0.0.1
  port 20001
</match>

```

Optional parameters are as follows:

- tag_sep: separator of tag name. default is "\t"
- send_time: Add send time to message in millisecond (ms) as integer for debug and performance/delay analysis
- send_time_key: An attribute of recv_time

## Contributing

1. Fork it ( http://github.com/toyokazu/fluent-plugin-tagged_udp/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
