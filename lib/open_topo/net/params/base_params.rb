# frozen_string_literal: true

module OpenTopo
  module Net
    module Params
      class BaseParams
        extend Forwardable

        def initialize
          @validation_result = nil

          if self.class.contract.nil?
            raise NotImplementedError, "Contract not configured"
          end
        end

        def to_params
          raise NotImplementedError, "Method to_params not implemented"
        end
        def_delegator :self, :to_params, :to_h

        def valid?
          validate
          validation_result.success?
        end

        def validate!
          if !valid?
            raise ::OpenTopo::Errors::ParamsError, "Invalid parameters: #{error_messages.join(", ")}"
          end

          true
        end

        def error_messages
          if !validation_result.nil? && !validation_result.success?
            validation_result.errors(full: true).messages.map(&:text)
          else
            []
          end
        end

        private

        attr_reader :validation_result

        def validate
          @validation_result = self.class.contract.new.call(to_params)
        end

        class << self
          attr_reader :contract

          def validate_with(contract)
            @contract = contract
          end
        end
      end
    end
  end
end
