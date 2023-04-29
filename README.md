# Salame sensor
Code for the temperature and humidity sensor and plotter, running on a
Raspberry Pi Zero W.

The sensor I'm using is a `BME280` and has to be connected to the I2C port of the
Raspberry. You can modify `read_sensor.py` to work with what you have, and just 
need to print two lines with temperature and humidity:

```bash
$> python read_sensor.py
22.31
45.54
```

The attached bash script is run by cron and executes `read_sensor.py` and pipes
it to the configured iotplotter.com feed.

# Setup

## 1. Clone the repo on your Raspberry Pi

```shell
$> git clone https://github.com/gingaramo/salame_sensor.git
```

## 2. Add your environment variables

Edit `/etc/environment` file to define your environment variables
at startup.

```bash
sudo nano /etc/environment
```

You'll need to define the following variables needed for cron and the bash script:

```bash
# Full path for the cloned repository (without trailing '/')
salame_script_full_path=/path/to/repository
# This is your feed id in iotplotter.com
salame_feed_id=<ID>
# Your private API key for iotplotter.com
iotplotter_api_key=<PRIVATE_KEY>
```

## 3. Edit crontab to run the script

First run:

```bash
crontab -e
```

And add these two lines to the bottom of the file:

```bash
# Run the script every minute of the day and pipe the output to a log file.
* * * * *  bash -c "bash $salame_script_full_path/script.sh 2>&1 | tee -a $salame_script_full_path/logs_$(date +\%Y_\%m_\%d).txt"
# Clear the log file every 7 days (604800 seconds)
0 5 * * * bash -c "bash rm $salame_script_full_path/logs_$(date -j -f %s $(($(date +%s)-604800)) +%Y_%m_%d).txt"
```

This will cause the script to run every minute, and you'll have a
handy log files for troubleshooting errors if there's any. The logs
will also be cleaned up after 7 days to avoid running our of disk space.