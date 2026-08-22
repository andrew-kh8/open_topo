# frozen_string_literal: true

module OpenTopo
  module Errors
    class FileError < BaseError
      attr_reader :file_path

      def initialize(message = "", file_path: nil)
        super(message)
        @file_path = file_path
      end

      def file
        return nil if @file_path.nil?

        File.open(@file_path)
      rescue Errno::ENOENT
        nil
      end
    end
  end
end
