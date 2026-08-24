# frozen_string_literal: true

require "dry-validation"

module OpenTopo
  module Net
    module Params
      module Contracts
        class UsgsdemContract < ::Dry::Validation::Contract
          params do
            required(:south).filled(:float, gt?: -90, lt?: 90)
            required(:north).filled(:float, gt?: -90, lt?: 90)
            required(:west).filled(:float, gt?: -180, lt?: 180)
            required(:east).filled(:float, gt?: -180, lt?: 180)
            required(:datasetName).filled(:string)
            required(:outputFormat).filled(:string)
          end

          rule(:south, :north) do
            key(:south).failure("must be less than north (#{values[:north]})") if values[:south] >= values[:north]
          end

          rule(:west, :east) do
            key(:west).failure("must be less than east (#{values[:east]})") if values[:west] >= values[:east]
          end

          rule(:datasetName) do
            key.failure("must be a valid DEM type") unless Params::UsgsdemParams::DEM_TYPES.value?(value)
          end

          rule(:outputFormat) do
            key.failure("must be a valid output format") unless Params::UsgsdemParams::OUTPUT_FORMATS.value?(value)
          end
        end
      end
    end
  end
end
