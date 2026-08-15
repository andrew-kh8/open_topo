# frozen_string_literal: true

module OpenTopo
  module Services
    class ResponseToDemConverter
      DATE_TIME_FORMAT = "%F-%H-%M-%S"
      FILE_WRITE_MODE = "wb"

      def self.call(response, dem_type:, output_format:)
        DemFile.new(original_file: file_from_response(response), dem_type:, output_format:)
      end

      class << self
        private

        def self.file_from_response(response)
          filename = filename_from_response(response)
          file = Tempfile.new([filename, ".tif"])

          file.binmode
          file.write(response.body)
          file.rewind
          file
        end

        def self.filename_from_response(response)
          response.headers.filename
        end
      end
    end
  end
end
