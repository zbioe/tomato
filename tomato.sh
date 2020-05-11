#!/bin/sh

set -o errexit
set -o nounset

usage() {
  cat <<EOF
Usage of $0:
  $0 [option] [message]

Options:
  -h, --help                     Show this message
  -w, --work-session <duration>  Duration of a work session (Default 25m)
  -s, --short-break <duration>   Duration of a short break (Default 5m)
  -l, --long-beak <duration>     Duration of a long break (Default 15m)
  -e, --cmd <string>             Command to execute when session is done

Examples:
  $0 -w 2m -s 30s -l 1m -e "notify-send 'end task'"
  $0 -e "/bin/custom_end_task.sh"
EOF
}

err() {
  echo "Err: "$1
  usage
  exit 1
}

while [ $# -gt 0 ] ; do
  nSkip=1
  case $1 in
    "-h"|"--help")
      usage
      exit 0
      ;;
    "--work-session"|"-w")
      nSkip=2
      ;;
    "--short-break"|"-s")
      nSkip=2
      ;;
    "--long-break"|"-l")
      nSkip=2
      ;;
    "-e"|"--cmd")
      nSkip=2
      ;;
    *)
      err "invalid option"
      ;;
  esac
  shift $nSkip
done
