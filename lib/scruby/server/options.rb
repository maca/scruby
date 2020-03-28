module Scruby
  class Server
    class Options
      extend Attributes
      include Enumerable

      attributes do
        attribute :bind_address, "127.0.0.1"
        attribute :protocol, :udp
        attribute :port, 57_110
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
        attribute :max_logins, 32
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

        attribute :jack_default_inputs, "system"
        attribute :jack_default_outputs, "system"
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

      def flags
        flags = [
          [ :B, bind_address ],
          [ (protocol.to_sym == :tcp ? :t : :u), port ],
          [ :a, total_audio_bus_channels ],
          [ :c, num_control_bus_channels ],
          [ :i, num_input_bus_channels ],
          [ :o, num_output_bus_channels ],
          [ :b, num_buffers ],
          [ :n, max_nodes ],
          [ :d, max_synth_defs ],
          [ :z, block_size ],
          [ :Z, hardware_buffer_size ],
          [ :m, mem_size ],
          [ :r, num_r_gens ],
          [ :w, num_wire_bufs ],
          [ :S, sample_rate ],
          [ :T, threads ],
          [ :V, verbosity ],
          [ :P, restricted_path ],
          [ :I, input_streams_enabled ],
          [ :O, output_streams_enabled ],
          [ (:L if memory_locking), "" ],
          ([ :D, 0 ] unless load_defs),
          ([ :R, 0 ] unless zero_conf),
          ([ :C, 1 ] if use_system_clock),
          [ :H, (devices.map(&:inspect).join(" ") if devices.any?) ],
          [ :U, ugen_plugins_path ],
          [ :l, max_logins ]
        ]

        flags.reduce("") do |str, (k, v)|
          next str if [ k, v ].any?(&:nil?)
          "#{str} -#{k} #{v}".strip
        end
      end

      def env
        {
          SC_JACK_DEFAULT_INPUTS: jack_default_inputs,
          SC_JACK_DEFAULT_OUTPUTS: jack_default_outputs
        }
      end
    end
  end
end
