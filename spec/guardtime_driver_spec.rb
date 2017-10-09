require "spec_helper"
require "date"

RSpec.describe Archangel::Driver::Guardtime do
  username = ENV['GUARDTIME_user']
  password = ENV['GUARDTIME_password']
  now = DateTime.now

  data = [
    ["fish", "halibut", now],
    ["fruit", "pomelo", DateTime.parse("2011-03-11 12:34:09")],
    ["corn-based-snack", "frazzles", now]
  ]

  before :context do
    # For this test to be 'realistic', our ids need to be unique across time
    data.map do |item|
      item[0] = "#{item[0]}-#{epoch_ms}"
    end
  end


  it "stores id:payload pairs" do
    skip "No Guardtime credentials available" if not username

    driver = Archangel::Driver::Guardtime.new(
      {
        :username => username,
        :password => password
      }
    )

    data.each do |id, payload, timestamp|
      driver.store(id, payload, timestamp)
    end
  end

  it "fetches payload given id" do
    skip "No Guardtime credentials available" if not username

    driver = Archangel::Driver::Guardtime.new(
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

def epoch_ms
  epoch_seconds = Time.now.to_f
  epoch_ms = (epoch_seconds * 1000).to_i
end
