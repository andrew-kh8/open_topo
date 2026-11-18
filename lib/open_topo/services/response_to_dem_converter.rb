# frozen_string_literal: true

require "fileutils"

module OpenTopo
  module Services
    class ResponseToDemConverter
      DATE_TIME_FORMAT = "%F-%H-%M-%S"

      def initialize(configuration)
        @configuration = configuration
      end

      def call(response, dem_type:, output_format:)
        DemFile.new(original_file: file_from_response(response), dem_type:, output_format:)
      end

      private

      attr_reader :configuration

      def file_from_response(response)
        return nil if !response.data?

        write_file(response)
      end

      def write_file(response)
        FileUtils.mkdir_p(configuration.file_dir)

        filename = response.headers.filename || "dem_#{Time.now.strftime(DATE_TIME_FORMAT)}"
        file = File.new(File.join(configuration.file_dir, "#{filename}.tif"), "w")

        file.binmode
        file.write(response.body)
        file.close

        File.open(file, "r")
      rescue SystemCallError, IOError, ArgumentError, TypeError => error
        raise OpenTopo::Errors::FileError.new(error.message, file_path: configuration.file_dir)
      end
    end
  end
end
