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
        return [] unless results.has_key? 'content'
        # Return metadata structs for all content
        # This probably needs to change to include the
        # hashes later on.
        results['content'].map{|x| x['metadata']}
        
      end # fetch
    end # Guardtime
  end # Driver
end # Archangel
