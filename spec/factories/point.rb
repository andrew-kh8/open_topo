FactoryBot.define do
  factory :point, class: "OpenTopo::Point" do
    long { -1.6028 }
    lat { 51.0176 }
    heigh { 100 }

    skip_create
    initialize_with { new(long:, lat:, heigh:) }
  end
end
