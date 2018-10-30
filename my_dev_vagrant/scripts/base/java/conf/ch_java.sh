#!/bin/bash
set -euo pipefail


if [[ $# -ne 1 ]]; then
  echo "Usage: $0 [ 6 or 7 or 8]" >&2
  exit 1
fi

case $1 in
  6)
    sudo update-alternatives --set java_home /usr/java/jdk1.6.0_45
    ;;
  7)
    sudo update-alternatives --set java_home /usr/java/jdk1.7.0_80
    ;;
  8)
    sudo update-alternatives --set java_home /usr/java/jdk1.8.0_144
    ;;
  *)
    echo "Usage: $0 [ 6 or 7 or 8]" >&2
    exit 1
    ;;
esac

java -version

echo
echo "JAVA_HOME"
echo "   "`readlink -f $JAVA_HOME`
