# frozen_string_literal: true

require "dry-validation"

module OpenTopo
  module Net
    module Params
      module Contracts
        class ElevationContract < ::Dry::Validation::Contract
          params do
            required(:longitude).filled(:float, gteq?: -180, lteq?: 180)
            required(:latitude).filled(:float, gteq?: -90, lteq?: 90)
            required(:dataset).filled(:string)
          end

          rule(:dataset) do
            key.failure("must be a valid dataset name") unless Params::ElevationParams::DATASETS.value?(value)
          end
        end
      end
    end
  end
end
