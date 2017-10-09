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

        gt_write(request_body)
      end # store

      def fetch(id)
        results = gt_search(id)

        result_count = results['content'] ? results['content'].length : 0
        if (result_count == 0)
          raise "No results found for #{id}"
        end
        if (result_count > 1)
          raise "Multiple results found for #{id}"
        end

        results['content'][0]['metadata']
      end # fetch

      private
      def gt_search(id)
        gt(:get, "?metadata.id=#{id}", nil)
      end # gt_search

      def gt_write(gt_payload)
        gt(:post, nil, gt_payload.to_json)
      end # gt_write

      def gt(method, params, payload)
        resp = RestClient::Request.execute(
          :method => method,
          :url => "#{@guardtime_url}#{params}",
          :user => @username,
          :password => @password,
          :headers => { :accept => :json, :content_type => :json },
          :payload => payload
        )
        JSON.parse(resp.to_str)
      end
    end # Guardtime

  end # Driver

end # Archangel
