# frozen_string_literal: true

module OpenTopo
  module Errors
    class BaseError < StandardError
      def initialize(message = "")
        super
      end
    end
  end
end
