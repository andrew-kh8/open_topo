# frozen_string_literal: true

require "dry-validation"

module OpenTopo
  module Net
    module Params
      module Contracts
        class CatalogContract < ::Dry::Validation::Contract
          COORDS = {
            minx: :west,
            miny: :south,
            maxx: :east,
            maxy: :north
          }

          params do
            optional(:minx).filled(:float, gteq?: -180, lteq?: 180)
            optional(:miny).filled(:float, gteq?: -90, lteq?: 90)
            optional(:maxx).filled(:float, gteq?: -180, lteq?: 180)
            optional(:maxy).filled(:float, gteq?: -90, lteq?: 90)
            optional(:polygon).filled(:string)

            required(:productFormat).filled(:string)
            required(:outputFormat).filled(:string)
            required(:detail).filled(:bool)
            required(:include_federated).filled(:bool)
          end

          rule(:polygon, :minx, :miny, :maxx, :maxy) do
            next if !values[:polygon].nil?

            if COORDS.keys.any? { |key| values[key].nil? }
              key(:base).failure("either polygon or all bounding box coordinates (#{COORDS.values.join(", ")}) must be provided")
            end
          end

          rule(:minx, :maxx) do
            next if values[:polygon]
            next if values[:minx].nil? || values[:maxx].nil?

            key(COORDS[:minx]).failure("must be less than #{COORDS[:maxx]} (#{values[:maxx]})") if values[:minx] >= values[:maxx]
          end

          rule(:miny, :maxy) do
            next if values[:polygon]
            next if values[:miny].nil? || values[:maxy].nil?

            key(COORDS[:miny]).failure("must be less than #{COORDS[:maxy]} (#{values[:maxy]})") if values[:miny] >= values[:maxy]
          end

          rule(:minx, :miny, :maxx, :maxy) do
            next if values[:polygon]

            missing = COORDS.keys.select { |key| values[key].nil? }
            missing.each do |key, value|
              key(COORDS[key]).failure("must be provided") if value.nil?
            end
          end

          rule(:polygon) do
            next if value.nil?

            coords = value.split(",")
            if coords.size.odd?
              key.failure("must consists of pairs of (longitude, latitude)")
              next
            end

            coords.map(&:to_f).each_slice(2).with_index do |(long, lat), index|
              key.failure("#{index} point - longitude must be less than or equal to 180") if long > 180
              key.failure("#{index} point - latitude must be less than or equal to 90") if lat > 90

              key.failure("#{index} point - longitude must be greater than or equal to -180") if long < -180
              key.failure("#{index} point - latitude must be greater than or equal to -90") if lat < -90
            end
          end
        end
      end
    end
  end
end
