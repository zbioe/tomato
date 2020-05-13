# Tomato

Just a simple implementation of pomodoro timer

# Features
- notify in your screen with `notify-send`
- make a noise using `alsa` when is time to change mode (focus mode, relax mode)
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
  -h, --help               Show this message
  -w, --work <duration>    Duration of a work session (Default 25m)
  -b, --break <duration>   Duration of a short break (Default 5m)
  -c, --cicles <number>    Number of Cicles (Default 4)
  -f, --file <filename>    File used for logging the mode changes (Default tempfile)
  -n, --notifier <script>  Script to use as notifier (Default notify)

Examples:
  ./tomato.sh -w 2m -b 30s -c 6
  ./tomato.sh -n "/bin/custom_notifier.sh"
  ./tomato.sh -w 5s -b 3s -c 3 -f custom.log

Notifier:
  notify <mode>  Called with a mode as arg

Modes:
  focus  Time to focus in your task
  relax  Time to take a break and relax
  end    You reached the end of the session
```
