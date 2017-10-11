#!/bin/bash

set -e
COINONATX_DATA=/home/coinonat/.CoinonatX
CONFIG_FILE=CoinonatX.conf

if [ -z $1 ] || [ "$1" == "CoinonatXd" ] || [ $(echo "$1" | cut -c1) == "-" ]; then
  cmd=CoinonatXd
  shift

  if [ ! -d $COINONATX_DATA ]; then
    echo "$0: DATA DIR ($COINONATX_DATA) not found, please create and add config.  exiting...."
    exit 1
  fi

  if [ ! -f $COINONATX_DATA/$CONFIG_FILE ]; then
    echo "$0: CoinonatXd config ($COINONATX_DATA/$CONFIG_FILE) not found, please create.  exiting...."
    exit 1
  fi

  chmod 700 "$COINONATX_DATA"
  chown -R coinonatx "$COINONATX_DATA"

  if [ -z $1 ] || [ $(echo "$1" | cut -c1) == "-" ]; then
    echo "$0: assuming arguments for CoinonatXd"

    set -- $cmd "$@" -datadir="$COINONATX_DATA"
  else
    set -- $cmd -datadir="$COINONATX_DATA"
  fi

  exec gosu coinonatx "$@"
elif [ "$1" == "coinonatx-cli" ] || [ "$1" == "coinonatx-tx" ]; then

  exec gosu coinonatx "$@"
else
  echo "This entrypoint will only execute CoinonatXd, coinonatx-cli and coinonatx-tx"
fi