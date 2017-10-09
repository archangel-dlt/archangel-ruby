require 'archangel/driver/guardtime_base'

module Archangel
  module Driver
    class GuardtimeV2 < GuardtimeBase
      def initialize(options = {
                       :username => nil,
                       :password => nil
                     })
        super(
          options,
          'https://tryout-catena-db.guardtime.net/api/v2/signatures'
        )
      end

      def store(id, payload, timestamp)
        gt_store(id, payload, timestamp)
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
        gt_get("/#{gt_id}")
      end
    end # Guardtime
  end # Driver
end # Archangel
