# frozen_string_literal: true

require "dry-validation"

module OpenTopo
  module Net
    module Params
      module Contracts
        class OtCatalogContract < ::Dry::Validation::Contract
          params do
            optional(:minx).filled(:float, gteq?: -180, lteq?: 180)
            optional(:miny).filled(:float, gteq?: -90, lteq?: 90)
            optional(:maxx).filled(:float, gteq?: -180, lteq?: 180)
            optional(:maxy).filled(:float, gteq?: -90, lteq?: 90)
            optional(:polygon).filled(:string)

            required(:productFormat).filled(:string)
            required(:detail).filled(:bool)
            required(:outputFormat).filled(:string)
            required(:include_federated).filled(:bool)
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

            key(:minx).failure("must be less than maxx (#{values[:maxx]})") if values[:minx] >= values[:maxx]
          end

          rule(:miny, :maxy) do
            next if values[:polygon]

            key(:miny).failure("must be less than maxy (#{values[:maxy]})") if values[:miny] >= values[:maxy]
          end

          rule(:minx, :miny, :maxx, :maxy) do
            next if values[:polygon]

            values.each do |key, value|
              key.failure("must be provided") if value.nil?
            end
          end

          # rule for polygon
        end
      end
    end
  end
end
