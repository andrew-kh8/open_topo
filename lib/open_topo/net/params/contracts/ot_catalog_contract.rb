# frozen_string_literal: true

require "dry-validation"

module OpenTopo
  module Net
    module Params
      module Contracts
        class OtCatalogContract < ::Dry::Validation::Contract
          params do
            optional(:productFormat).filled(:string)
            optional(:minx).filled(:float, gt?: -180, lt?: 180)
            optional(:miny).filled(:float, gt?: -90, lt?: 90)
            optional(:maxx).filled(:float, gt?: -180, lt?: 180)
            optional(:maxy).filled(:float, gt?: -90, lt?: 90)
            optional(:polygon).filled(:string)
            optional(:detail).filled(:bool)
            optional(:outputFormat).filled(:string)
            optional(:include_federated).filled(:bool)
          end

          rule(:polygon, :minx, :miny, :maxx, :maxy) do
            if values[:polygon].nil?
              missing = %i[minx miny maxx maxy].select { |key| values[key].nil? }
              if missing.any?
                key(:base).failure("either polygon or all bounding box coordinates (minx, miny, maxx, maxy) must be provided")
              end
            end
          end

          rule(:minx, :maxx) do
            next if values[:polygon]
            next if values[:minx].nil? || values[:maxx].nil?

            key(:minx).failure("must be less than maxx (#{values[:maxx]})") if values[:minx] >= values[:maxx]
          end

          rule(:miny, :maxy) do
            next if values[:polygon]
            next if values[:miny].nil? || values[:maxy].nil?

            key(:miny).failure("must be less than maxy (#{values[:maxy]})") if values[:miny] >= values[:maxy]
          end

          rule(:productFormat) do
            next if value.nil?

            key.failure("must be a valid product format") unless Params::OtCatalogParams::PRODUCT_FORMATS.value?(value)
          end
        end
      end
    end
  end
end
