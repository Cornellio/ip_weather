#!/bin/bash
#
# Weather forecast tool, by Pete Cornell, 2019

progname="$(basename $0)"
location_api="http://ipinfo.io"
weather_api="https://api.darksky.net/forecast/6ce2cb95ebf7afee7f2d76afcc037fb3"

# Get geographic locatoin for given ip
get_location () {

  ip=$1
  geolocation=$(curl -s ${location_api}/${ip}?token=${location_api_token} \
    | jq '.loc' 2> /dev/null)

  # a non-zero exit status may mean bad api token
  if [[ $? != 0 ]]; then
    echo "Bad response from ${location_api}. Check your api token."
    exit 1
  fi

  # a null response may mean invalid IP
  if [[ $geolocation == "null" ]]; then
    echo "Bad response from ${location_api}. Did you supply a valid IP?"
    exit 1
  fi

  # strip out quotes
  geolocation=${geolocation//\"}

}

get_weather () {

  geolocation=$1

  # Default to 3 days of forecast if not specified by user
  let forecast_days=${user_forecast_days:-3}

  result="Weather forecast for ${ip:-current location}"

  for ((day=0; day<${forecast_days}; day++)); do

    # Set query strings for jq
    query_summary=".daily.data[$day:$day+1] | .[].summary"
    query_time=".daily.data[$day:$day+1] | .[].time"

    summary=$(curl -s "${weather_api}/${geolocation}" | jq "${query_summary}")
    summary=${summary//\"}

    time=$(curl -s "${weather_api}/${geolocation}" | jq "${query_time}")
    time=$(date --date=@${time} +%Y-%m-%d)

    result+="\n${time}: ${summary}"
  done

  printf "$result\n"

}

parse_args () {

  # Consume first argument if it's an ip address and store it
  if [[ $1 =~ [0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3} ]]; then
    ip=$1
    shift
  fi

  # Handle optional values for api token and number of days to check
  while getopts 't:d:h' OPTION; do
    case $OPTION in
      t) location_api_token=$OPTARG ;;
      d) user_forecast_days=$OPTARG ;;
      *) echo_usage ;;
    esac
  done

}

echo_usage () {
  cat <<- EOM
  Usage: ${progname} [ip address] [options]
  ip address is optional. Your current public ip will be used
  if none is given. When supplied it must be the first argument.
  Options:
    -t  api token to use with ipinfo.io, defaults to none
    -d  number of days to forecast, defaults to 3
    -h  show help message
EOM
  exit 0
}

main () {
  get_location $ip
  get_weather $geolocation
}

parse_args $*
main

