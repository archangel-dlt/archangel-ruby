require 'json'
require 'digest'

module Archangel
  
  module Driver
    
    class Filesystem < Base
      
      def initialize(options = {})
      end
      
      def store(id, time, payload)
        # Hash ID and time
        filename =  Digest::SHA256.hexdigest("#{id}-#{time}")+".json"
        # Write payload to file
        File.open(filename, "w") do |f|
          output = {
            "id" => id,
            "timestamp" => time.iso8601,
            "payload" => payload
          }
          f.write output.to_json
        end
      end
      
    end
    
  end
  
end