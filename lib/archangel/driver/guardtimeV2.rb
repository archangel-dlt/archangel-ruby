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
        return [] unless gt_ids.has_key? 'ids'
        # Return metadata structs for all content
        # This probably needs to change to include the
        # hashes later on.
        gt_ids['ids'].map do |id|
          gt_fetch(id)['metadata']
        end
      end # fetch

      private
      def gt_fetch(gt_id)
        gt_get("/#{gt_id}")
      end
    end # Guardtime
  end # Driver
end # Archangel
