# typed: strict
# frozen_string_literal: true

module OpenTopo
  class Catalog
    attr_reader :full_name, :name, :url, :date_created, :temporal_coverage, :unit

    def initialize(full_name:, name:, url:, date_created:, temporal_coverage:, unit: "meter")
      @full_name = full_name
      @name = name
      @url = url
      @date_created = date_created
      @temporal_coverage = temporal_coverage
      @unit = unit
    end
  end
end
