require 'archangel/driver/guardtime_base'

module Archangel
  module Driver
    class Guardtime < GuardtimeBase
      def initialize(options = {
                       :username => nil,
                       :password => nil
                     })
        super(
          options,
          'https://tryout-catena-db.guardtime.net/api/v1/signatures'
        )
      end

      def store(id, payload, timestamp)
        gt_store(id, payload, timestamp)
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
    end # Guardtime
  end # Driver
end # Archangel
