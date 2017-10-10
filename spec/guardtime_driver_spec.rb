require "spec_helper"
require "date"

username = ENV['GUARDTIME_user']
password = ENV['GUARDTIME_password']

use_vcr = !username

username ||= "username"
password ||= "password"

RSpec.shared_examples "GuardTime" do |gt_driver|
  drivername = gt_driver.name.split('::').last

  data = [
    ["fish", "halibut", DateTime.parse("2016-11-02 10:12:59")],
    ["fruit", "pomelo", DateTime.parse("2011-03-11 12:34:09")],
    ["corn-based-snack", "frazzles", DateTime.parse("2015-12-12 12:00:00")]
  ]

  before :context do
    annotation = use_vcr ? drivername : epoch_ms
    data.map do |item|
      item[0] = "#{item[0]}-#{annotation}"
    end
  end


  it "stores id:payload pairs", :vcr => { :cassette_name => "#{drivername}-store" } do
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

  it "fetches payload given id", :vcr => { :cassette_name => "#{drivername}-fetch" } do
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

def epoch_ms
  epoch_seconds = Time.now.to_f
  epoch_ms = (epoch_seconds * 1000).to_i
end
