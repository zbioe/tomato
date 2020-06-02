#!/bin/sh

set -o errexit
set -o nounset

usage() {
  cat <<EOF
Usage:
  $0 [OPTION]...

Options:
  -h, --help                Show this message
  -w, --work <duration>     Duration of a work session (Default 25m)
  -b, --break <duration>    Duration of a short break (Default 5m)
  -c, --cycles <number>     Number of cycles (Default 4)
  -f, --file <filename>     File used for logging the mode changes (Default tempfile)
  -n, --notifier <command>  Script to use as notifier (Default default_notifier)

Examples:
  $0 -w 2m -b 30s -c 6
  $0 -n "./example_notifier.sh"
  $0 -w 5s -b 3s -c 3 -f custom.log

Notifier:
  notify <mode>  Called with a mode as arg

Modes:
  work   Time to work in your task
  break  Time to take a break and relax
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
    break) song=pink;;
    work|end) song=sine;;
  esac
  (
    speaker-test -l 1 -p 1 -t $song &
  ) 1>/dev/null 2>&1
}

default_notifier() {
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
    "--cycles"|"-c")
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
default_n=default_notifier

W=${w-$default_w}
B=${b-$default_b}
C=${c-$default_c}
N=${n-$default_n}

case ${f-""} in
  "") logFile=$(mktemp --suffix=-tomato)
      trap "rm -f $logFile" EXIT ;;
  *) logFile=$f ;;
esac

echo "Work: $W"
echo "Break: $B"
echo "Cycles: $C"
echo "Notifier: $N"
echo "Log file: $logFile"

while [ $C -gt 0 ]
do
  $N work
  log work >> $logFile
  sleep $W
  C=$(($C - 1))
  case $C in
    0)
      log end >> $logFile
      $N end
      break
      ;;
    *)
      $N break
      log break >> $logFile
      sleep $B
  esac
done

exit 0

