#!/bin/sh

set -o errexit
set -o nounset

usage() {
  cat <<EOF
Usage:
  $0 [OPTION]...

Options:
  -h, --help               Show this message
  -w, --work <duration>    Duration of a work session (Default 25m)
  -b, --break <duration>   Duration of a short break (Default 5m)
  -c, --cicles <number>    Number of Cicles (Default 4)
  -f, --file <filename>    File used for logging the mode changes (Default tempfile)
  -n, --notifier <script>  Script to use as notifier (Default notify)

Examples:
  $0 -w 2m -b 30s -c 6
  $0 -n "/bin/custom_notifier.sh"
  $0 -w 5s -b 3s -c 3 -f custom.log

Notifier:
  notify <mode>  Called with a mode as arg

Modes:
  focus  Time to focus in your task
  relax  Time to take a break and relax
  end	 You reached the end of the session

EOF
}

err() {
  echo "Err: "$1
  usage
  exit 1
}

noise() {
  case $1 in
    relax) song=pink;;
    focus|end) song=sine;;
  esac
  (
    speaker-test -l 1 -p 1 -t $song &
  ) 1>/dev/null 2>&1
}

notify() {
  notify-send "$@"
  which speaker-test 1>/dev/null 2>&1 && noise "$@"
}

log() {
  echo $(date +%d-%m-%Y_%H-%M-%S)" $@"
}

while [ $# -gt 0 ] ; do
  nSkip=2
  case $1 in
    "-h"|"--help")
      usage
      exit 0
      ;;
    "--work"|"-w")
      w=$2
      ;;
    "--break"|"-b")
      b=$2
      ;;
    "--cicles"|"-c")
      c=$2
      ;;
    "--file"|"-f")
      f=$2
      ;;
    "--notifier"|"-n")
      n=$2
      ;;
    *)
      err "invalid option"
      ;;
  esac
  shift $nSkip
done

default_w="25m"
default_b="5m"
default_c="4"
default_n=notify

W=${w-$default_w}
B=${b-$default_b}
C=${c-$default_c}
N=${n-$default_n}

case ${f-""} in
  "") logFile=$(mktemp --suffix=-tomato)
      trap "rm -f $logFile" EXIT ;;
  *) logFile=$f ;;
esac

echo "Setted"
echo "Work: $W"
echo "Relax: $B"
echo "Cicles: $C"
echo "Notifier: $N"
echo "Log file: $logFile"

while [ $C -ge 0 ]
do
  $N focus
  log focus >> $logFile
  sleep $W
  case $C in
    1)
      log end >> $logFile
      $N end
      break
      ;;
    *)
      $N relax
      log relax >> $logFile
      sleep $B
  esac
  C=$(expr $C - 1)
done

exit 0

