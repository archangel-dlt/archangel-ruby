<<<<<<< HEAD
# VCR breaks the fetch, for reasons I can't work out
# so only run ethereum tests if a local Ethereum REST endpoint
# is available
require "net/http"
require "uri"

endpoint = true
begin
  Net::HTTP.get_response(URI.parse("http://localhost:8545"))
rescue
  endpoint = false
end

RSpec.describe Archangel::Driver::EtherStore do
  before {
    if (!endpoint)
      skip("No Ethereum endpoint available")
    end
  }

  include_examples "a storage backend" do
    let(:driver) {
      Archangel::Driver::EtherStore.new(
          {
          }
      )
    }
    let(:annotation) { SecureRandom.hex(10) }
  end
end

