#!/bin/bash

# Set the URL to which the POST request will be sent
url=http://iotplotter.com/api/v2/feed/809378137363634641.csv

# Run the Python program and capture the first two lines of output (temp and humidity)
output=$(python /home/gaston/Salame/run.py | head -n 2)

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
wget -O /dev/null --post-data="$data" --header="api-key: 22535ff29fc1949a72bca65267621d0416c948090d" "$url"

