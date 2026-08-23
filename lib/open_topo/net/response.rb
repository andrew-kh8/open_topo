# frozen_string_literal: true

module OpenTopo
  module Net
    class Response
      NOT_FOUND_MESSAGE = "Not found"
      NO_DATA_MESSAGE = "No data"

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
        @body = set_body_message(response)
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

      def set_body_message(response)
        case response.status
        when 204 then NO_DATA_MESSAGE
        when 404 then NOT_FOUND_MESSAGE
        else
          response.body
        end
      end
    end
  end
end
