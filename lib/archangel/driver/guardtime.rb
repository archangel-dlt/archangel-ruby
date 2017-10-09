require 'digest'
require 'rest-client'
require 'json'

module Archangel

  module Driver

    class Guardtime < Base
      def initialize(options = {
                       :username => nil,
                       :password => nil
                     })
        if (!options[:username] || !options[:password])
          raise "Guardtime driver needs authentication credentials"
        end

        @username = options[:username]
        @password = options[:password]
        @guardtime_url = 'https://tryout-catena-db.guardtime.net/api/v1/signatures'
      end

      def store(id, payload, timestamp)
        datahash = Digest::SHA256.base64digest("#{id}-#{payload}")
        request_body = {
            :metadata => {
              :id => id,
              :payload => payload,
              :timestamp => timestamp.iso8601
            },
            :dataHash => {
              :value => datahash,
              :algorithm => "SHA-256"
            },
            :level => 0
          }

        response = RestClient::Request.execute(
          :method => :post,
          :url => @guardtime_url,
          :user => @username,
          :password => @password,
          :headers => { :accept => :json, :content_type => :json },
          :payload => request_body.to_json
        )
      end

    end

  end

end
