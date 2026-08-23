# frozen_string_literal: true

module OpenTopo
  module Net
    class Response
      attr_reader :body, :headers, :status

      Headers = Struct.new(:date, :content_disposition, :content_length, :content_type) do
        def filename
          if content_disposition.nil? || !content_disposition.match?(filename_header)
            return nil
          end

          File.basename(content_disposition.split(filename_header).last.delete('"'), ".*")
        end

        private

        def filename_header = "filename="
      end

      def initialize(response)
        @body = response.body
        @headers = parse_headers(response.headers)
        @status = response.status
      end

      def success?
        (200..299).cover?(status)
      end

      def failure?
        !success?
      end

      def data?
        success? && status != 204
      end

      private

      def parse_headers(headers)
        Headers.new(
          headers["Date"],
          headers["Content-Disposition"],
          headers["Content-Length"],
          headers["Content-Type"]
        )
      end
    end
  end
end
