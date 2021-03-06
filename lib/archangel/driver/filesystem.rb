require 'json'
require 'digest'
require 'archangel/driver/base'

module Archangel

  module Driver

    class Filesystem < Base

      def initialize(options = {:root => "."})
        @root = options[:root] || "."
      end

      def store(id, payload, timestamp)
        # Hash ID and time
        filename =  Digest::SHA256.hexdigest("#{id}-#{timestamp}")+".json"
        # Write payload to file
        File.open("#{@root}/#{filename}", "w") do |f|
          output = {
            "id" => id,
            "timestamp" => timestamp.iso8601,
            "payload" => payload
          }
          f.write output.to_json
        end
      end

      def fetch(id)
        Dir["#{@root}/*.json"].map do |file|
          data = JSON.parse(File.read(file))
          data["id"] == id ? data : nil
        end.compact.sort_by! { |o| o["timestamp"] }
      end

    end

  end

end
