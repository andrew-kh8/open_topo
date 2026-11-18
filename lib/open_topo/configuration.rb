# frozen_string_literal: true

module OpenTopo
  class Configuration
    DEFAULT_FILE_DIR = "./open_topo_files"
    DEFAULT_GLOBAL_DATASET = :srtmgl3
    DEFAULT_USGS_DATASET = :usgs10m
    DEFAULT_ELEVATION_DATASET = :srtmgl3
    DEFAULT_OUTPUT_FORMAT = :tif

    UPDATABLE_ATTRIBUTES = %i[
      file_dir
      global_dataset
      usgs_dataset
      elevation_dataset
      output_format
    ].freeze

    attr_reader :file_dir
    attr_accessor :global_dataset, :usgs_dataset, :elevation_dataset, :output_format

    def initialize(
      file_dir: DEFAULT_FILE_DIR,
      global_dataset: DEFAULT_GLOBAL_DATASET,
      usgs_dataset: DEFAULT_USGS_DATASET,
      elevation_dataset: DEFAULT_ELEVATION_DATASET,
      output_format: DEFAULT_OUTPUT_FORMAT
    )
      self.file_dir = file_dir
      self.global_dataset = global_dataset
      self.usgs_dataset = usgs_dataset
      self.elevation_dataset = elevation_dataset
      self.output_format = output_format
    end

    def update(attributes)
      attributes = attributes.slice(*UPDATABLE_ATTRIBUTES).compact

      self.file_dir = attributes.fetch(:file_dir) { file_dir }
      self.global_dataset = attributes.fetch(:global_dataset) { global_dataset }
      self.usgs_dataset = attributes.fetch(:usgs_dataset) { usgs_dataset }
      self.elevation_dataset = attributes.fetch(:elevation_dataset) { elevation_dataset }
      self.output_format = attributes.fetch(:output_format) { output_format }

      self
    end

    def file_dir=(value)
      @file_dir = normalize_file_dir(value)
    end

    private

    def normalize_file_dir(value)
      path = path_from(value)
      raise OpenTopo::Errors::FileError.new("file_dir must not be empty", file_path: value) if path.empty?

      expanded_path = File.expand_path(path)
      if File.exist?(expanded_path) && !File.directory?(expanded_path)
        raise OpenTopo::Errors::FileError.new("file_dir must be a directory", file_path: expanded_path)
      end

      expanded_path.freeze
    rescue OpenTopo::Errors::FileError
      raise
    rescue ArgumentError, TypeError, SystemCallError => error
      raise OpenTopo::Errors::FileError.new(error.message, file_path: value)
    end

    def path_from(value)
      if value.is_a?(String)
        value
      elsif value.respond_to?(:to_path)
        value.to_path
      else
        raise OpenTopo::Errors::FileError.new("file_dir must be a path", file_path: value)
      end
    end
  end
end
