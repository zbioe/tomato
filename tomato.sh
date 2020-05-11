#!/bin/sh

set -o errexit
set -o nounset

usage() {
  cat <<EOF
Usage of $0:
  $0 [OPTION]...

Options:
  -h, --help               Show this message
  -w, --work <duration>    Duration of a work session (Default 25m)
  -b, --break <duration>   Duration of a short break (Default 5m)
  -c, --cicles <number>    Number of Cicles (Default 4)
  -n, --notifyer <script>  Script to use as notifyer (Default notify-send with speaker-test)

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
  (
    speaker-test -l 1 -p 1 -t sine &
  ) 1>/dev/null 2>&1
}

notify() {
  notify-send "$@"
  which speaker-test 1>/dev/null 2>&1 && noise
}

while [ $# -gt 0 ] ; do
  nSkip=2
  case $1 in
    "-h"|"--help")
      usage
      exit 0
      ;;
    "--work"|"-w")
      ws=$2
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

while [ $C -ge 0 ]
do
  $N "focus mode"
  sleep $W
  $N "relax mode"
  sleep $B
  C=$(expr $C - 1)
done

exit 0

