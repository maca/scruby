module Scruby
  class Server
    class Options
      extend Attributes
      include Enumerable

      attributes do
        attribute :bind_address, "127.0.0.1"
        attribute :protocol, :udp
        attribute :num_audio_bus_channels, 1024
        attribute :num_control_bus_channels, 16_384
        attribute :num_input_bus_channels, 2
        attribute :num_output_bus_channels, 2
        attribute :num_buffers, 1024
        attribute :max_nodes, 1024
        attribute :max_synth_defs, 1024
        attribute :block_size, 64
        attribute :hardware_buffer_size, nil
        attribute :mem_size, 8192
        attribute :num_r_gens, 64
        attribute :num_wire_bufs, 64
        attribute :sample_rate, nil
        attribute :threads, nil
        attribute :load_defs, true
        attribute :zero_conf, false
        attribute :use_system_clock, false
        attribute :verbosity, 0
        attribute :restricted_path, nil
        attribute :input_streams_enabled, nil
        attribute :output_streams_enabled, nil
        attribute :memory_locking, false
        attribute :in_device, nil
        attribute :out_device, nil
        attribute :ugen_plugins_path, nil
        attribute :max_logins, 4
        attribute :num_private_audio_bus_channels, 1020
        attribute :remote_control_volume, false
        attribute :reserved_num_audio_bus_channels, 0
        attribute :reserved_num_control_bus_channels, 0
        attribute :reserved_num_buffers, 0
        attribute :pings_before_considered_dead, 5
        attribute :rec_header_format, "aiff"
        attribute :rec_sample_format, "float"
        attribute :rec_channels, 2
        attribute :rec_buf_size, nil
        # attribute :initial_node_id, 1000
      end

      def ugen_plugins_path=(paths)
        super paths && [ *paths ].map { |p| File.expand_path(p) }
                        .join(File::PATH_SEPARATOR)
      end

      def total_audio_bus_channels
        num_private_audio_bus_channels +
          num_input_bus_channels +
          num_output_bus_channels
      end

      def devices
        [ in_device, out_device ]
      end

      def address
        bind_address
      end

      def each(&block)
        attributes.each(&block)
      end
    end
  end
end
