module Archangel

  module Driver

    class Base

      def initialize(options = {})
        raise_error
      end

      def store(id, payload, time)
        raise_error
      end

      private

      def raise_error
        raise "Do not use Archangel::Driver::Base directly. Set a driver instead."
      end

    end

  end

end
