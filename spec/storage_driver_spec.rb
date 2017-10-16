require "spec_helper"
require "date"

RSpec.shared_examples "a storage backend" do
  let(:data) {
    [
      ["fish-#{annotation}", "halibut", DateTime.parse("2016-11-02 10:12:59")],
      ["fruit-#{annotation}", "pomelo", DateTime.parse("2011-03-11 12:34:09")],
      ["corn-based-snack-#{annotation}", "frazzles", DateTime.parse("2015-12-12 12:00:00")]
    ]
  }

  it "stores id:payload pairs", :vcr => { :cassette_name => "#{@cassette_name}-store" } do
    data.each do |id, payload, timestamp|
      driver.store(id, payload, timestamp)
    end
  end

  it "fetches payload given id", :vcr => { :cassette_name => "#{@cassette_name}-fetch" } do
    data.each do |id, payload, timestamp|
      read = driver.fetch(id)

      expect(read["id"]).to eq id
      expect(read["payload"]).to eq payload
      expect(read["timestamp"]).to eq timestamp.iso8601
    end
  end
end
