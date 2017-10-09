require 'digest'
require 'rest-client'
require 'json'
require 'archangel/driver/base'

module Archangel

  module Driver

    class GuardtimeBase < Base
      def initialize(options, url)
        if (!options[:username] || !options[:password])
          raise "Guardtime driver needs authentication credentials"
        end

        @username = options[:username]
        @password = options[:password]
        @guardtime_url = url
      end

      protected
      def gt_store(id, payload, timestamp)
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

      def gt_search(id)
        gt_get("?metadata.id=#{id}")
      end # gt_search

      def gt_write(gt_payload)
        gt_post(gt_payload)
      end # gt_write

      def gt_get(params)
        gt(:get, params, nil)
      end

      def gt_post(gt_payload)
        gt(:post, nil, gt_payload.to_json)
      end

      private
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
    end # GuardtimeBase
  end # Driver
end # Archangel
