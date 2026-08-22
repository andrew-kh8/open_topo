# typed: strict
# frozen_string_literal: true

module OpenTopo
  class DemFile
    attr_reader :original_file
    alias_method :file, :original_file

    attr_reader :dem_type

    attr_reader :output_format

    def initialize(original_file:, dem_type:, output_format:)
      @original_file = original_file
      @dem_type = dem_type
      @output_format = output_format
    end

    def convert_to(format, file_path: nil)
      Services::DemConverter.call(original_file, format, file_path: file_path)
    end
  end
end
