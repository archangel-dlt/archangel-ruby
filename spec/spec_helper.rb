require "bundler/setup"
require "archangel"
require "vcr"
require "storage_driver_tests"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

VCR.configure do |config|
  config.cassette_library_dir = "spec/vcr_cassettes"
  config.allow_http_connections_when_no_cassette = true
  config.hook_into :webmock
  config.configure_rspec_metadata!
  config.before_record do |i|
    i.request.headers.delete('Authorization')
  end
end

