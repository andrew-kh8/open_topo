# OpenTopo

[![CodeFactor](https://www.codefactor.io/repository/github/andrew-kh8/open_topo/badge)](https://www.codefactor.io/repository/github/andrew-kh8/open_topo)

---

- [Installation](#installation)
  - [GDAL](#gdal)
- [Usage](#usage)
- [Development and contributing](#development-and-contributing)
- [License](#license)
- [Code of Conduct](#code-of-conduct)

## Installation

Install as usual gem:

```ruby
gem "open_topo"
```

or

```sh
gem install open_topo
```

### GDAL

ubuntu quick install with `apt-get install gdal-bin`

and check with `gdalinfo --version` or `gdal_translate --version`

in case of issues check:

- [stackoverflow answer](https://stackoverflow.com/questions/72887400/install-gdal-on-linux-ubuntu-20-04-4lts-for-python)
- [gdal doc](https://gdal.org/en/stable/)

## Usage

Request an API key via [myOpenTopo](https://portal.opentopography.org/myopentopo) in the OpenTopography portal.
Only `#catalog` endpoint not required api key

```ruby
# init client with api key or just set env OPEN_TOPOGRAPHY_API_KEY
client = OpenTopo::Client.new(api_key)

client.globaldem(north:, south:, west:, east:) # => OpenTopo::DemFile
client.usgsdem(south:, north:, west:, east:) # => OpenTopo::DemFile
client.elevation(long:, lat:) # => OpenTopo::Point
client.catalog(west:, south: , east:, north:) # => [OpenTopo::Catalog]
client.catalog(polygon:) # => [OpenTopo::Catalog]
```

Optional dataset and output format overrides: `client.globaldem(..., dataset: :srtmgl1, output_format: :asc)`, `client.usgsdem(..., dataset_name: :usgs30m)`, `client.elevation(..., dataset: :cop30)`.

DEM files are saved into `./open_topo_files` by default. Use `OpenTopo.configure` to change the default for clients created afterwards:

```ruby
OpenTopo.configure do |config|
  config.file_dir = "./my_dem_files"
  config.global_dataset = :srtmgl1
  config.usgs_dataset = :usgs30m
  config.elevation_dataset = :cop30
  config.output_format = :asc
end

client = OpenTopo::Client.new(api_key)
```

Available options:

| Option | Default | Used by |
|---|---|---|
| `file_dir` | `./open_topo_files` | `#globaldem`, `#usgsdem` |
| `global_dataset` | `:srtmgl3` | `#globaldem` |
| `usgs_dataset` | `:usgs10m` | `#usgsdem` |
| `elevation_dataset` | `:srtmgl3` | `#elevation` |
| `output_format` | `:tif` | `#globaldem`, `#usgsdem` |

Each client receives its own copy of the configuration and accepts the same options as keyword arguments to override the defaults for that client:

```ruby
client_a = OpenTopo::Client.new(api_key, file_dir: "./dem_a", global_dataset: :srtmgl1)
client_b = OpenTopo::Client.new(api_key, file_dir: "./dem_b", global_dataset: :cop30)
```

The current defaults are available via `OpenTopo.configuration`, and `OpenTopo.reset_configuration!` restores them.

`file_dir` is expanded to an absolute path, supports `~`, and is validated. Invalid paths raise `OpenTopo::Errors::FileError`. The directory is created automatically when the first DEM file is saved. Converted CSV files are written next to the original TIF, so they use the same directory by default.

## Development and contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/andrew-kh8/open_topo.
This project is intended to be a safe, welcoming space for collaboration,
and contributors are expected to adhere to the [code of conduct](https://github.com/andrew-kh8/open_topo/blob/master/CODE_OF_CONDUCT.md).

Everyone interacting in the OpenTopo project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/andrew-kh8/open_topo/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
