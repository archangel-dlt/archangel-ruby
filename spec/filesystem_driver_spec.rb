require "spec_helper"
require "date"

RSpec.describe Archangel::Driver::Filesystem do
  test_id = "fish"
  test_payload = "halibut"
  now = DateTime.now
  filestore = "./test_run"

  data = [
    ["fish", "halibut", now],
    ["fruit", "pomelo", now],
    ["corn-based-snack", "frazzles", now]
  ]

  before :context do
    FileUtils.mkdir(filestore)
  end

  after :context do
    FileUtils.remove_dir(filestore)
  end

  it "stores id:payload pairs" do
    data.each do |id, payload, timestamp|
      count = filecount(filestore)

      driver = Archangel::Driver::Filesystem.new({root: filestore})
      driver.store(id, payload, timestamp)

      expect(filecount(filestore)).to be count+1
    end
  end
end

def filecount(dir)
  Dir["#{dir}/*.json"].length
end
