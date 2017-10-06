require "spec_helper"
require "date"

RSpec.describe Archangel::Driver::Filesystem do
  test_id = "fish"
  test_payload = "halibut"
  now = DateTime.now
  filestore = "./test_run"

  data = [
    ["fish", "halibut", now],
    ["fruit", "pomelo", DateTime.parse("2011-03-11 12:34:09")],
    ["corn-based-snack", "frazzles", now]
  ]

  before :context do
    FileUtils.mkdir(filestore)
  end

  after :context do
    FileUtils.remove_dir(filestore)
  end

  it "stores id:payload pairs" do
    driver = Archangel::Driver::Filesystem.new({"root" => filestore})

    data.each do |id, payload, timestamp|
      count = filecount(filestore)

      driver.store(id, payload, timestamp)

      expect(filecount(filestore)).to eq count+1
    end
  end

  it "fetches payload given id" do
    driver = Archangel::Driver::Filesystem.new({"root" => filestore})

    data.each do |id, payload, timestamp|
      read = driver.fetch(id)

      expect(read["id"]).to eq id
      expect(read["payload"]).to eq payload
      expect(read["timestamp"]).to eq timestamp.iso8601
    end
  end
end

def filecount(dir)
  Dir["#{dir}/*.json"].length
end
