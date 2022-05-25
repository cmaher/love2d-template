#!/usr/bin/env bash

while read dep; do
  name_version=$(echo $dep | awk '{print $1} {print $2}')
  $LUAROCKS install $name_version
done < .luarocks.lock
