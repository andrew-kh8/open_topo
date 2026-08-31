# frozen_string_literal: true

module OpenTopo
  module Services
    class ResponseToCatalogListConverter
      def self.call(data)
        datasets = data&.dig("Datasets", "Dataset")
        return [] if datasets.nil?

        datasets.map do |dataset|
          created_at = dataset["temporalCoverage"].split(" / ").map { |string_date| Date.parse(string_date) }

          OpenTopo::Catalog.new(
            full_name: dataset["name"],
            name: dataset["alternateName"],
            url: dataset["url"],
            date_created: dataset["dateCreated"],
            temporal_coverage: {from: created_at[0], to: created_at[1]},
            unit: dataset["spatialCoverage"]["additionalProperty"].find { |p| p["name"] == "Unit" }&.fetch("value")
          )
        end
      end
    end
  end
end
