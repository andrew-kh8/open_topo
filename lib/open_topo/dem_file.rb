# typed: strict
# frozen_string_literal: true

module OpenTopo
  class DemFile
    attr_reader :original_file
    alias_method :file, :original_file

    attr_reader :dem_type

    attr_reader :output_format

    attr_reader :csv

    def initialize(original_file:, dem_type:, output_format:)
      @original_file = original_file
      @dem_type = dem_type
      @output_format = output_format
      @csv = nil
    end

    def build_csv
      @csv ||= Services::GeoToCsvConverter.call(original_file)
      @csv
    end
  end
end
