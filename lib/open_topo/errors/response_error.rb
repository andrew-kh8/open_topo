# frozen_string_literal: true

module OpenTopo
  module Errors
    class ResponseError < BaseError
      def initialize(message = "")
        super(message.is_a?(Hash) ? message["error"] || message : message)
      end
    end
  end
end
