module Connectors
  module Opennebula
    class GroupHandler < Handler
      EXCLUDE = %w[oneadmin users].freeze

      def initialize
        super
        @pool = OpenNebula::GroupPool.new client
      end

      def exclude
        self.class::EXCLUDE
      end
    end
  end
end
