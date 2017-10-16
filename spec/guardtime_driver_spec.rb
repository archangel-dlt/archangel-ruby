require "storage_driver_spec"
require "securerandom"

username = ENV['GUARDTIME_user']
password = ENV['GUARDTIME_password']

use_vcr = !username
tag = use_vcr ? "(VCR)" : ""

username ||= "username"
password ||= "password"

if use_vcr
  VCR.configure do |config|
    config.cassette_library_dir = "spec/vcr_cassettes"
    config.allow_http_connections_when_no_cassette = true
    config.hook_into :webmock
    config.configure_rspec_metadata!
    config.before_record do |i|
      i.request.headers.delete('Authorization')
    end
  end
end

[ Archangel::Driver::Guardtime, Archangel::Driver::GuardtimeV2 ].each do |gt_class|
  name = gt_class.name.split('::').last
  annotation = use_vcr ? name : SecureRandom.hex(10)

  RSpec.describe "#{gt_class.name} #{tag}" do
    @cassette_name = name
    include_examples "a storage backend" do
      let(:driver) {
        gt_class.new(
          {
            :username => username,
            :password => password
          }
        )
      }
      let(:annotation) { annotation }
    end
  end
end
