# typed: strict
# frozen_string_literal: true

module Apis
  module OpenTopo
    class DemFile
      extend T::Sig

      sig { returns(File) }
      attr_reader :tif
      alias_method(:tiff, :tif)

      sig { returns(String) }
      attr_reader :dem_type

      sig { returns(String) }
      attr_reader :output_format

      sig { returns(T.nilable(CSV)) }
      attr_reader :csv

      sig { params(tif: File, dem_type: String, output_format: String).void }
      def initialize(tif:, dem_type:, output_format:)
        @tif = tif
        @dem_type = dem_type
        @output_format = output_format
        @csv = T.let(nil, T.nilable(CSV))
      end
    end
  end
end
