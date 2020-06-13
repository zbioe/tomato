# Tomato

Just a simple implementation of pomodoro timer

# Features
- notify in your screen with `notify-send`
- make a noise using command `speaker-test` from `alsa` when is time to change mode (work, break, end)
- You can create a custom notifyer scrit, you just need to receive the mode passed as argument
- log the mode change in a  file
- extensible notifier, just create a script who receive the mode as arg and pass it by `-n` flag

# Install

Get the script from this repository
``` shell
curl -O https://raw.githubusercontent.com/zbioe/tomato/master/tomato.sh
```
   
Move it to some folder in your `$PATH`
``` shell
sudo mv tomato.sh /usr/local/bin/tomato
```

# Usage

For see the usage you can just use `tomato -h`

``` text
Usage:
  ./tomato.sh [OPTION]...

Options:
  -h, --help                Show this message
  -w, --work <duration>     Duration of a work session (Default 25m)
  -b, --break <duration>    Duration of a short break (Default 5m)
  -c, --cycles <number>     Number of cycles (Default 4)
  -f, --file <filename>     File used for logging the mode changes (Default tempfile)
  -n, --notifier <command>  Script to use as notifier (Default default_notifier)

Examples:
  ./tomato.sh -w 2m -b 30s -c 6
  ./tomato.sh -n "./example_notifier.sh"
  ./tomato.sh -w 5s -b 3s -c 3 -f custom.log

Notifier:
  notify <mode>  Called with a mode as arg

Modes:
  work   Time to work in your task
  break  Time to take a break and relax
  end    You reached the end of the session
```
