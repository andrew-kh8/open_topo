# Requests

## otCatalog

### params

#### time and size

set default params to get required data and decrease response time/size

```
outputFormat: "xml",
detail: false
```

example:

- current params = 2kB
- with json format = 17.4kB
- with detail = 31.9kB
- json + detail = 108kB

#### required data

Set include_federated to false to get rid of unnecessary data.
All of federated datasets have no `alternateName` or something like that, so now
there's no opportunity to get request for their data.

Investigate it in future

#### product format

set productFormat to "Raster", because there's no opportunity to request data of point cloud datasets