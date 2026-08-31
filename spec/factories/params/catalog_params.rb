FactoryBot.define do
  factory :catalog_params, class: "OpenTopo::Net::Params::CatalogParams" do
    east { 121.5 }
    west { 121 }
    north { 84.5 }
    south { 84 }

    polygon { nil }

    trait :polygon do
      east { nil }
      west { nil }
      north { nil }
      south { nil }

      polygon { "-117.5,32.5,-117.5,33.1,-116.7,33.1,-116.7,32.5,-117.0,32.3,-117.5,32.5" }
    end

    skip_create
    initialize_with { new(west:, south:, east:, north:, polygon:) }
  end
end
