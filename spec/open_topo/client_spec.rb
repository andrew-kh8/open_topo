# frozen_string_literal: true

RSpec.describe OpenTopo::Client do
  let(:instance) { described_class.new(ENV["OPEN_TOPOGRAPHY_API_KEY"]) }

  describe "#configuration" do
    after { OpenTopo.reset_configuration! }

    context "when the module configuration changes after client creation" do
      let(:client) { described_class.new(ENV["OPEN_TOPOGRAPHY_API_KEY"]) }

      before do
        OpenTopo.configure { |config| config.file_dir = "./default_dem_files" }
        client
        OpenTopo.configuration.file_dir = "./changed_dem_files"
      end

      it "copies the default configuration" do
        expect(client.configuration.file_dir).to eq File.expand_path("./default_dem_files")
      end
    end

    context "with a per-client configuration" do
      subject(:client) do
        described_class.new(
          ENV["OPEN_TOPOGRAPHY_API_KEY"],
          configuration: OpenTopo::Configuration.new(file_dir: "./custom_dem_files")
        )
      end

      it "uses the configuration file directory" do
        expect(client.configuration.file_dir).to eq File.expand_path("./custom_dem_files")
      end
    end

    context "with a file directory override" do
      subject(:client) do
        described_class.new(
          ENV["OPEN_TOPOGRAPHY_API_KEY"],
          configuration: OpenTopo::Configuration.new(file_dir: "./config_dem_files", global_dataset: :cop30),
          file_dir: "./override_dem_files"
        )
      end

      it "overrides only the configuration file directory" do
        expect(client.configuration.file_dir).to eq File.expand_path("./override_dem_files")
        expect(client.configuration.global_dataset).to eq :cop30
      end
    end

    context "with multiple clients" do
      let(:first_client) { described_class.new(ENV["OPEN_TOPOGRAPHY_API_KEY"], file_dir: "./first_dem_files") }
      let(:second_client) { described_class.new(ENV["OPEN_TOPOGRAPHY_API_KEY"], file_dir: "./second_dem_files") }

      it "keeps per-client file directories independent" do
        expect(first_client.configuration.file_dir).to eq File.expand_path("./first_dem_files")
        expect(second_client.configuration.file_dir).to eq File.expand_path("./second_dem_files")
      end
    end
  end

  describe "#globaldem" do
    context "with valid parameters" do
      let(:globaldem) { instance.globaldem(south: 42.45580075467154, north: 42.45911160123194, west: 25.526535836979747, east: 25.53120849654078) }

      after { File.delete(globaldem.file) if File.exist?(globaldem.file) }

      it "returns a DEM file" do
        VCR.use_cassette("globaldem/success_request") do
          expect(globaldem).to be_a(OpenTopo::DemFile)
        end
      end
    end

    context "with configured defaults" do
      let(:configuration) { OpenTopo::Configuration.new(global_dataset: :cop30, output_format: :asc) }
      let(:client) { described_class.new(ENV["OPEN_TOPOGRAPHY_API_KEY"], configuration:) }
      let(:params) { instance_double(OpenTopo::Net::Params::GlobaldemParams, validate!: true) }
      let(:request) { instance_double(OpenTopo::Net::Request) }
      let(:response) { instance_double(OpenTopo::Net::Response, success?: true) }
      let(:dem_file) { instance_double(OpenTopo::DemFile) }

      it "uses configuration values as defaults" do
        expect(OpenTopo::Net::Params::GlobaldemParams).to receive(:new)
          .with(south: 1, north: 2, west: 3, east: 4, demtype: :cop30, output_format: :asc)
          .and_return(params)
        expect(client).to receive(:request).and_return(request)
        expect(request).to receive(:globaldem).with(params).and_return(response)
        expect(OpenTopo::Services::ResponseToDemConverter).to receive(:call)
          .with(response, dem_type: :cop30, output_format: :asc, configuration: client.configuration)
          .and_return(dem_file)

        expect(client.globaldem(south: 1, north: 2, west: 3, east: 4)).to eq(dem_file)
      end

      it "passes a dataset override as demtype" do
        expect(OpenTopo::Net::Params::GlobaldemParams).to receive(:new)
          .with(south: 1, north: 2, west: 3, east: 4, demtype: :srtmgl1, output_format: :asc)
          .and_return(params)
        expect(client).to receive(:request).and_return(request)
        expect(request).to receive(:globaldem).with(params).and_return(response)
        expect(OpenTopo::Services::ResponseToDemConverter).to receive(:call)
          .with(response, dem_type: :srtmgl1, output_format: :asc, configuration: client.configuration)
          .and_return(dem_file)

        expect(client.globaldem(south: 1, north: 2, west: 3, east: 4, dataset: :srtmgl1)).to eq(dem_file)
      end
    end

    context "with invalid parameters" do
      context "when the parameters are validated with failure" do
        let(:globaldem) { instance.globaldem(south: 42.455, north: 42.459, west: 25.52, east: 25.52) }
        let(:error_message) { "Invalid parameters: west must be less than east (25.52)" }

        it "raises an error" do
          expect { globaldem }.to raise_error(OpenTopo::Errors::ParamsError, error_message)
        end
      end

      context "when request fails" do
        let(:globaldem) { instance.globaldem(south: -42.45580075467154, north: 42.45911160123194, west: -25.526535836979747, east: 25.53120849654078) }
        let(:error_message) do
          "Error: The maximum area for SRTMGL3 is 4,050,000 km2. The selected area is 50,526,423 km2."
        end

        it "raises an error" do
          VCR.use_cassette("globaldem/failure_large_area") do
            expect { globaldem }.to raise_error(OpenTopo::Errors::ResponseError, error_message)
          end
        end
      end
    end
  end

  describe "#usgsdem" do
    context "with valid parameters" do
      let(:usgsdem) { instance.usgsdem(south: 40.4898, north: 40.49, west: -88.5398, east: -88.52, dataset_name: :usgs30m) }

      after { File.delete(usgsdem.file) if File.exist?(usgsdem.file) }

      it "returns a DEM file" do
        VCR.use_cassette("usgsdem/success_request") do
          expect(usgsdem).to be_a(OpenTopo::DemFile)
        end
      end
    end

    context "with configured defaults" do
      let(:configuration) { OpenTopo::Configuration.new(usgs_dataset: :usgs30m, output_format: :hfa) }
      let(:client) { described_class.new(ENV["OPEN_TOPOGRAPHY_API_KEY"], configuration:) }
      let(:params) { instance_double(OpenTopo::Net::Params::UsgsdemParams, validate!: true) }
      let(:request) { instance_double(OpenTopo::Net::Request) }
      let(:response) { instance_double(OpenTopo::Net::Response, success?: true) }
      let(:dem_file) { instance_double(OpenTopo::DemFile) }

      it "uses configuration values as defaults" do
        expect(OpenTopo::Net::Params::UsgsdemParams).to receive(:new)
          .with(south: 1, north: 2, west: 3, east: 4, dataset_name: :usgs30m, output_format: :hfa)
          .and_return(params)
        expect(client).to receive(:request).and_return(request)
        expect(request).to receive(:usgsdem).with(params).and_return(response)
        expect(OpenTopo::Services::ResponseToDemConverter).to receive(:call)
          .with(response, dem_type: :usgs30m, output_format: :hfa, configuration: client.configuration)
          .and_return(dem_file)

        expect(client.usgsdem(south: 1, north: 2, west: 3, east: 4)).to eq(dem_file)
      end
    end

    context "with invalid parameters" do
      context "when the parameters are validated with failure" do
        let(:usgsdem) { instance.usgsdem(south: 40.49, north: 40.49, west: -88.5398, east: -88.52, dataset_name: :usgs30m) }
        let(:error_message) { "Invalid parameters: south must be less than north (40.49)" }

        it "raises an error" do
          expect { usgsdem }.to raise_error(OpenTopo::Errors::ParamsError, error_message)
        end
      end

      context "when request returns 204" do
        let(:usgsdem) { instance.usgsdem(south: -25.52, north: 25.52, west: -42.45, east: 42.45, dataset_name: :usgs30m) }

        it "raises an error" do
          VCR.use_cassette("usgsdem/failure_no_data") do
            expect(usgsdem.file).to be_nil
          end
        end
      end

      context "when request fails" do
        let(:usgsdem) { instance.usgsdem(south: 40.489999, north: 40.49, west: -88.5398, east: -88.52, dataset_name: :usgs30m) }
        let(:error_message) do
          "Error: The selected area is too small: 0 km2."
        end

        it "raises an error" do
          VCR.use_cassette("usgsdem/failure_small_area") do
            expect { usgsdem }.to raise_error(OpenTopo::Errors::ResponseError, error_message)
          end
        end
      end
    end
  end

  describe "#elevation" do
    context "with valid parameters" do
      let(:elevation) { instance.elevation(long: params.long, lat: params.lat) }
      let(:param_class) { OpenTopo::Net::Params::ElevationParams }
      let(:params) { build(:elevation_params, long: -1.6028, lat: 51.0176) }
      let(:request) { double }
      let(:response) { double(success?: true, body: {elevation: 100}) }
      let(:point) { build(:point, heigh: 100) }

      it "returns a Point" do
        expect(param_class).to receive(:new).with(long: params.long, lat: params.lat, dataset: :srtmgl3).and_return(params)
        expect(params).to receive(:validate!).and_return(true)

        expect(instance).to receive(:request).and_return(request)
        expect(request).to receive(:elevation).with(params).and_return(response)
        expect(OpenTopo::Services::ResponseToPointConverter).to receive(:call).with(response).and_return(point)

        expect(elevation).to be_a(OpenTopo::Point)
        expect(elevation).to eq(point)
      end
    end

    context "with configured defaults" do
      let(:configuration) { OpenTopo::Configuration.new(elevation_dataset: :cop30) }
      let(:client) { described_class.new(ENV["OPEN_TOPOGRAPHY_API_KEY"], configuration:) }
      let(:params) { instance_double(OpenTopo::Net::Params::ElevationParams, validate!: true) }
      let(:request) { instance_double(OpenTopo::Net::Request) }
      let(:response) { instance_double(OpenTopo::Net::Response, success?: true) }
      let(:point) { instance_double(OpenTopo::Point) }

      it "uses the configured dataset as the default" do
        expect(OpenTopo::Net::Params::ElevationParams).to receive(:new)
          .with(long: 1, lat: 2, dataset: :cop30)
          .and_return(params)
        expect(client).to receive(:request).and_return(request)
        expect(request).to receive(:elevation).with(params).and_return(response)
        allow(OpenTopo::Services::ResponseToPointConverter).to receive(:call).and_return(point)

        expect(client.elevation(long: 1, lat: 2)).to eq(point)
      end
    end

    context "with invalid parameters" do
      context "when the parameters are validated with failure" do
        let(:elevation) { instance.elevation(long: 200, lat: 51.0176) }
        let(:error_message) { "Invalid parameters: longitude must be less than or equal to 180" }

        it "raises an error" do
          expect { elevation }.to raise_error(OpenTopo::Errors::ParamsError, error_message)
        end
      end

      context "when request fails" do
        let(:elevation) { instance.elevation(long: -150, lat: 50) }
        let(:error_message) { "Not found" }

        it "raises an error" do
          VCR.use_cassette("elevation/failure_no_data") do
            expect { elevation }.to raise_error(OpenTopo::Errors::ResponseError, error_message)
          end
        end
      end
    end
  end

  describe "#catalog" do
    subject { instance.catalog(west:, south:, east:, north:, polygon:) }

    # let(:params_class) { instance_double(OpenTopo::Net::Params::CatalogParams) }
    let(:params) { build(:catalog_params) }
    let(:north) { 84.5 }
    let(:south) { 84 }
    let(:west) { 121 }
    let(:east) { 121.5 }
    let(:polygon) { nil }
    let(:request) { instance_double(OpenTopo::Net::Request) }
    let(:response) { instance_double(OpenTopo::Net::Response, success?: response_success, body: response_body) }
    let(:response_body) { {foo: "bar"} }

    context "when response is success" do
      let(:catalog_list) { [] }
      let(:response_success) { true }

      it "returns catalog list" do
        expect(OpenTopo::Net::Params::CatalogParams).to receive(:new).with(west:, south:, east:, north:, polygon:).and_return(params).ordered
        expect(params).to receive(:validate!).and_return(true).ordered

        expect(instance).to receive(:request).and_return(request).ordered
        expect(request).to receive(:catalog).with(params).and_return(response).ordered
        expect(OpenTopo::Services::ResponseToCatalogListConverter).to receive(:call).with(response.body).and_return(catalog_list).ordered

        subject
      end
    end

    context "when response is failure" do
      let(:response_success) { false }

      it "raises an error" do
        expect(OpenTopo::Net::Params::CatalogParams).to receive(:new).with(west:, south:, east:, north:, polygon:).and_return(params).ordered
        expect(params).to receive(:validate!).and_return(true).ordered

        expect(instance).to receive(:request).and_return(request).ordered
        expect(request).to receive(:catalog).with(params).and_return(response).ordered

        expect(OpenTopo::Services::ResponseToCatalogListConverter).not_to receive(:call).ordered

        expect { subject }.to raise_error(OpenTopo::Errors::ResponseError, response_body.to_s)
      end
    end
  end
end
