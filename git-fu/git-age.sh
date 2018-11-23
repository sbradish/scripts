#!/bin/bash

pushd () {
    command pushd "$@" > /dev/null
}

popd () {
    command popd "$@" > /dev/null
}

while getopts ":r" opt; do
  case ${opt} in
    r ) # process option r
      RECURSIVE="-r"
      ;;
    \? ) echo "Usage: git-age.sh [-r]"
      exit 1
      ;;
  esac
done

shift $(($OPTIND - 1))
pushd .
cd $@

FILES="$(git ls-tree ${RECURSIVE} --name-only HEAD .)"
MAXLEN=0
IFS="$(printf "\n\b")"
for f in $FILES; do
    if [ ${#f} -gt $MAXLEN ]; then
        MAXLEN=${#f}
    fi
done
for f in $FILES; do
    str="$(git log -1 --pretty=format:"%ci" $f)"
    printf "%-${MAXLEN}s -- %s\n" "$str" "$f" 
done

popd
