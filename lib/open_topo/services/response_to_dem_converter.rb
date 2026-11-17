# frozen_string_literal: true

require "fileutils"

module OpenTopo
  module Services
    class ResponseToDemConverter
      DATE_TIME_FORMAT = "%F-%H-%M-%S"

      def self.call(response, dem_type:, output_format:, configuration:)
        DemFile.new(original_file: file_from_response(response, configuration), dem_type:, output_format:)
      end

      class << self
        private

        def file_from_response(response, configuration)
          return nil if !response.data?

          write_file(response, configuration.file_dir)
        end

        def write_file(response, file_dir)
          FileUtils.mkdir_p(file_dir)

          filename = filename_from_response(response)
          file = File.new(File.join(file_dir, "#{filename}.tif"), "w")

          file.binmode
          file.write(response.body)
          file.close

          File.open(file, "r")
        rescue SystemCallError, IOError, ArgumentError, TypeError => error
          raise OpenTopo::Errors::FileError.new(error.message, file_path: file_dir)
        end

        def filename_from_response(response)
          response.headers.filename || "dem_#{Time.now.strftime(DATE_TIME_FORMAT)}"
        end
      end
    end
  end
end
