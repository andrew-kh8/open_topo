# frozen_string_literal: true

require "fileutils"

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
          return nil if !response.data?

          file_dir = OpenTopo.configuration.file_dir
          FileUtils.mkdir_p(file_dir)

          filename = filename_from_response(response)
          file = File.new(File.join(file_dir, "#{filename}.tif"), "w")

          file.binmode
          file.write(response.body)
          file.close

          File.open(file, "r")
        end

        def filename_from_response(response)
          response.headers.filename || "dem_#{Time.now.strftime(DATE_TIME_FORMAT)}"
        end
      end
    end
  end
end
