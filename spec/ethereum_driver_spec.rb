require "storage_driver_spec"

RSpec.describe Archangel::Driver::Ethereum do
  include_examples "a storage backend" do
    let(:driver) {
      Archangel::Driver::Ethereum.new(
        {
        }
      )
    }
    let(:annotation) { SecureRandom.hex(10) }
  end
end
