FactoryBot.define do
  factory :elevation_params, class: "OpenTopo::Net::Params::ElevationParams" do
    long { -1.6028 }
    lat { 51.0176 }
    dataset { :srtmgl3 }

    skip_create
    initialize_with { new(long:, lat:, dataset:) }
  end
end
