require "bundler/setup"
require "byebug"
require "scruby"

Dir.glob(File.join(__dir__, "support/**/*.rb")).each { |f| load f }


include Scruby::Helpers


RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
    c.max_formatted_output_length = 1000
  end
end

Thread.abort_on_exception = true
