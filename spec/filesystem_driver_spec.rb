require "spec_helper"
require "date"

RSpec.describe Archangel::Driver::Filesystem do
  test_id = "fish"
  test_payload = "halibut"
  timestamp = DateTime.now
  filestore = "./test_run"

  before :context do
    FileUtils.mkdir(filestore)
  end

  after :context do
    FileUtils.remove_dir(filestore)
  end

  it "stores a id:payload pair" do
    count = filecount(filestore)

    driver = Archangel::Driver::Filesystem.new({root: filestore})
    driver.store(test_id, test_payload, timestamp)

    expect(filecount(filestore)).to be count+1
  end
end

def filecount(dir)
  Dir["#{dir}/*.json"].length
end
