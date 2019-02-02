## Weather Forecast Tool

This script will fetch the weather forecast for a given IP address using the DarkSky weather API. The location of the given IP will be fetched using ipinfo.io.

## Requirements

The script assumes `jq` from stedolan.github.io/jq/ is installed and in your path. Also, `curl` and `date`are needed.

## Running

Running the script without arguments will display the weather forecast for your current location.

```
./ip_forecast.sh
Weather forecast for current location
2019-01-25: Partly cloudy overnight.
2019-01-26: Mostly cloudy throughout the day.
2019-01-27: Mostly cloudy throughout the day.
```

## Optional arguments

You can choose the number of days to forecast using `-d` and set an API token to use when calling ipinfo.io with `-t` if desired.

```
./ip_forecast.sh 128.138.129.2 -d 5 -t 65b51897c0XXXX
Weather forecast for 128.138.129.2
2019-01-24: Partly cloudy starting in the evening.
2019-01-25: Breezy and partly cloudy until afternoon.
2019-01-26: Breezy throughout the day and mostly cloudy until evening.
2019-01-27: Light snow (< 1 in.) in the morning.
2019-01-28: Windy until afternoon.
```

Finally, running with `-h` will show basic usage info.

## Assumptions

This was tested on Ubuntu Linux 17.10.
