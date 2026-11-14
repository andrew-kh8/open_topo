# frozen_string_literal: true

module OpenTopo
  class Configuration
    attr_accessor :file_dir

    def initialize
      @file_dir = OpenTopo::DEFAULT_FILE_DIR
    end
  end
end
