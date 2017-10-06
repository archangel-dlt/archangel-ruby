require "spec_helper"
require "date"

RSpec.describe Archangel::Driver::Filesystem do
  test_id = "fish"
  test_payload = "halibut"
  timestamp = DateTime.now()

  it "stores a id:payload pair" do
    driver = Archangel::Driver::Filesystem.new()
    driver.store(test_id, test_payload, timestamp)
  end
end
