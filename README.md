# Tomato

Just a simple pomodoro time manager

# Install

Get the script from this repository
``` shell
curl -O https://raw.githubusercontent.com/zbioe/tomato/master/tomato.sh
```

Move then for a folder in your `$PATH`

``` shell
sudo mv tomato.sh /usr/local/bin
```

# Usage

For see the usage you can just use `tomato -h`

``` text
Usage:
  ./tomato.sh [OPTION]...

Options:
  -h, --help               Show this message
  -w, --work <duration>    Duration of a work session (Default 25m)
  -b, --break <duration>   Duration of a short break (Default 5m)
  -c, --cicles <number>    Number of Cicles (Default 4)
  -n, --notifyer <script>  Script to use as notifyer (Default notify-send with speaker-test)

Examples:
  ./tomato.sh -w 2m -b 30s -c 6
  ./tomato.sh -n "/bin/custom_notifyer.sh"

Notifyer:
  notify [message]
```
