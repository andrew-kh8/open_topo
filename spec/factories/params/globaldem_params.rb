FactoryBot.define do
  factory :globaldem_params, class: "OpenTopo::Net::Params::GlobaldemParams" do
    south { 42.45580075467154 }
    north { 42.45911160123194 }
    west { 25.526535836979747 }
    east { 25.53120849654078 }
    demtype { :srtmgl3 }
    output_format { :tif }

    skip_create
    initialize_with { new(south:, north:, west:, east:, demtype:, output_format:) }
  end
end
