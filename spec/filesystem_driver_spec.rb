require "storage_driver_spec"

RSpec.describe Archangel::Driver::Filesystem do
  filestore = "./test_run"

  before :context do
    FileUtils.mkdir(filestore)
  end

  after :context do
    FileUtils.remove_dir(filestore)
  end

  include_examples "a storage backend" do
    let(:driver) {
      Archangel::Driver::Filesystem.new(
        {
          :root => filestore
        }
      )
    }
    let(:annotation) { "file" }
  end
end
