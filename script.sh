#!/bin/bash

# Ensure these environment variables exist
if [ -z "$salame_feed_id" ]; then
  echo "salame_feed_id environment variable is not defined"
fi
if [ -z "$salame_script_full_path" ]; then
  echo "script_full_path environment variable is not defined"
fi
if [ -z "$iotplotter_api_key" ]; then
  echo "iotplotter_api_key environment variable is not defined"
fi

# Set the URL to which the POST request will be sent
url=http://iotplotter.com/api/v2/feed/$salame_feed_id.csv

# Run the Python program and capture the first two lines of output (temp and humidity)
output=$(python $salame_script_full_path/read_sensor.py | head -n 2)

# Assign the first line
temperature=$(echo "$output" | sed -n 1p)

# Assign the second line
humidity=$(echo "$output" | sed -n 2p)

# Print the values of the variables
echo "temperature: $temperature"
echo "humidity: $humidity"

data=$(cat <<EOF
0,Salame_Temperature,$temperature
0,Salame_Humidity,$humidity
EOF
)

echo "data: $data"
logger $data
wget -O /dev/null --post-data="$data" --header="api-key: $iotplotter_api_key" "$url"

