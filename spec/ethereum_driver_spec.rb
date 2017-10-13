RSpec.describe Archangel::Driver::EtherStore do 
#               :vcr => { :cassette_name => "Ethereum" } do
  include_examples "a storage backend" do
    let(:driver) {
      Archangel::Driver::EtherStore.new(
        {
        }
      )
    }
    let(:annotation) { 'ethereum-2017' }
  end
end
