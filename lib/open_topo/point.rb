# frozen_string_literal: true

module OpenTopo
  class Point
    attr_reader :long
    alias_method :longitude, :long

    attr_reader :lat
    alias_method :latitude, :lat

    attr_reader :heigh
    alias_method :elevation, :heigh

    attr_reader :unit

    def initialize(long:, lat:, heigh: nil, unit: "m")
      @long = long
      @lat = lat
      @heigh = heigh
      @unit = unit
    end
  end
end
