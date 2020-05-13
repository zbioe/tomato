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
  -n, --notifyer <script>  Script to use as notifyer (Default notify)

Examples:
  $0 -w 2m -b 30s -c 6
  $0 -n "/bin/custom_notifyer.sh"

Notifyer:
  notify [message]
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
    "--notifyer"|"-n")
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

statusFile=$(mktemp --suffix=-tomato)
cleanup(){
  [ -f $statusFile ] && rm -f $statusFile
}
trap cleanup 0 1 2 3 6

echo "Setted"
echo "Work: $W"
echo "Relax: $B"
echo "Cicles: $C"
echo "Notifyer: $N"
echo "Status file: $statusFile"

while [ $C -ge 0 ]
do
  $N focus
  log focus >> $statusFile
  sleep $W
  case $C in
    1)
      log end >> $statusFile
      $N end
      break
      ;;
    *)
      $N relax
      log relax >> $statusFile
      sleep $B
  esac
  C=$(expr $C - 1)
done

exit 0

