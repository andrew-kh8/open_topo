FactoryBot.define do
  factory :usgsdem_params, class: "OpenTopo::Net::Params::UsgsdemParams" do
    south { 40.4898 }
    north { 40.49 }
    west { -88.5398 }
    east { -88.52 }
    dataset_name { :usgs30m }
    output_format { :tif }

    skip_create
    initialize_with { new(south:, north:, west:, east:, dataset_name:, output_format:) }
  end
end
