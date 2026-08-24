# typed: strict
# frozen_string_literal: true

require "open3"

module OpenTopo
  module Services
    class DemConverter
      FILENAME_EXT_SPLITTER = ".*"

      def self.call(file, file_format, file_path: nil)
        if file.nil? || !File.file?(file)
          raise OpenTopo::Errors::FileError.new("File is not a file (#{file.class})", file_path: file)
        end

        new_filename = build_new_filename(file, file_path, file_format)
        original_filename = file.path

        _message, error, status = Open3.capture3(gdal_translate_command(original_filename, new_filename))

        if status.success?
          File.open(new_filename, "r")
        else
          raise OpenTopo::Errors::ConvertError, error.strip
        end
      end

      class << self
        private

        def build_new_filename(file, file_path, file_format)
          extname = File.extname(file_path.to_s)
          ext = extname.empty? ? ".#{file_format}" : extname
          file_path = file.path if file_path.nil? || file_path.empty?

          if !File.directory?(file_path) && File.extname(file_path).empty?
            raise OpenTopo::Errors::FileError.new("No such file or directory", file_path:)
          end

          path, filename =
            if File.directory?(file_path.to_s)
              [file_path, File.basename(file.path, FILENAME_EXT_SPLITTER)]
            else
              [File.dirname(file_path), File.basename(file_path, FILENAME_EXT_SPLITTER)]
            end

          File.join(path, "#{filename}#{ext}")
        end

        def gdal_translate_command(original_filename, new_filename)
          "gdal_translate -of XYZ -co COLUMN_SEPARATOR=, -co ADD_HEADER_LINE=YES #{original_filename} #{new_filename}"
        end
      end
    end
  end
end
