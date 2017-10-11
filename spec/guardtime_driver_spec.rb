require "spec_helper"
require "date"
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

RSpec.shared_examples "GuardTime" do |gt_driver|
  drivername = gt_driver.name.split('::').last

  data = [
    ["fish", "halibut", DateTime.parse("2016-11-02 10:12:59")],
    ["fruit", "pomelo", DateTime.parse("2011-03-11 12:34:09")],
    ["corn-based-snack", "frazzles", DateTime.parse("2015-12-12 12:00:00")]
  ]

  before :context do
    annotation = use_vcr ? drivername : SecureRandom.hex(10)
    data.map do |item|
      item[0] = "#{item[0]}-#{annotation}"
    end
  end


  it "stores id:payload pairs #{tag}", :vcr => { :cassette_name => "#{drivername}-store" } do
    driver = gt_driver.new(
      {
        :username => username,
        :password => password
      }
    )

    data.each do |id, payload, timestamp|
      driver.store(id, payload, timestamp)
    end
  end

  it "fetches payload given id #{tag}", :vcr => { :cassette_name => "#{drivername}-fetch" } do
    driver = gt_driver.new(
      {
        :username => username,
        :password => password
      }
    )

    data.each do |id, payload, timestamp|
      read = driver.fetch(id)

      expect(read["id"]).to eq id
      expect(read["payload"]).to eq payload
      expect(read["timestamp"]).to eq timestamp.iso8601
    end
  end
end

[ Archangel::Driver::Guardtime, Archangel::Driver::GuardtimeV2 ].each do |gt_class|
  RSpec.describe gt_class.name do
    include_examples "GuardTime", gt_class
  end
end
