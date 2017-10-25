require "securerandom"

username = ENV['GUARDTIME_user']
password = ENV['GUARDTIME_password']

use_vcr = !username
tag = use_vcr ? "(VCR)" : ""

username ||= "username"
password ||= "password"

[ Archangel::Driver::Guardtime, Archangel::Driver::GuardtimeV2 ].each do |gt_class|
  name = gt_class.name.split('::').last
  vcr_opts = use_vcr ? { :cassette_name => "#{name}", :record => :new_episodes } : nil
  annotation = use_vcr ? name : SecureRandom.hex(10)

  RSpec.describe "#{gt_class.name} #{tag}",
                 :vcr => vcr_opts do
    include_examples "a storage backend" do
      let(:driver) {
        gt_class.new(
          {
            :username => username,
            :password => password
          }
        )
      }
      let(:annotation) { annotation }
    end
  end
end
