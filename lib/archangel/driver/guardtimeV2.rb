require 'digest'
require 'rest-client'
require 'json'
require 'archangel/driver/base'

module Archangel
  module Driver
    class GuardtimeV2 < Base
      def initialize(options = {
                       :username => nil,
                       :password => nil
                     })
        if (!options[:username] || !options[:password])
          raise "Guardtime driver needs authentication credentials"
        end

        @username = options[:username]
        @password = options[:password]
        @guardtime_url = 'https://tryout-catena-db.guardtime.net/api/v2/signatures'
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
        gt_ids = gt_search(id)

        result_count = gt_ids['ids'] ? gt_ids['ids'].length : 0
        if (result_count == 0)
          raise "No results found for #{id}"
        end
        if (result_count > 1)
          raise "Multiple results found for #{id}"
        end

        result = gt_fetch(gt_ids['ids'][0])
        result['metadata']
      end # fetch

      private
      def gt_fetch(gt_id)
        gt(:get, "/#{gt_id}", nil)
      end

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
