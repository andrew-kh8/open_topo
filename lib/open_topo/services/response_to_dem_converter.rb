# frozen_string_literal: true

require "tempfile"

module OpenTopo
  module Services
    class ResponseToDemConverter
      DATE_TIME_FORMAT = "%F-%H-%M-%S"

      def self.call(response, dem_type:, output_format:)
        DemFile.new(original_file: file_from_response(response), dem_type:, output_format:)
      end

      class << self
        private

        def file_from_response(response)
          filename = filename_from_response(response)
          file = Tempfile.new([filename, ".tif"])

          file.binmode
          file.write(response.body)
          file.rewind
          file
        end

        def filename_from_response(response)
          response.headers.filename || "dem_#{Time.now.strftime(DATE_TIME_FORMAT)}"
        end
      end
    end
  end
end
