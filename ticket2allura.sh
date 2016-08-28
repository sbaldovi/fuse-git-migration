#!/bin/bash

# Traslate ticket numbers for SourceForge's project fuse-emulator from the old
# bug tracking system to Allura

#   svn log | grep -o -E "#[0-9][0-9][0-9][0-9]+" | sort | uniq | \
#       xargs -I{} ticket2allura.sh {} >> tickets_map.txt

AID_BUG=596648
AID_PATCH=596650
AID_FEATURE=596651
GROUP_ID=91293
TICKET=

get_ticket() {
  OLD_URL="https://sourceforge.net/tracker/?func=detail&atid="$1"&aid="${2//#/}"&group_id="$GROUP_ID
  NEW_URL=`curl -ILs -w "%{url_effective}\n" "$OLD_URL" | tail -1`
  case "$NEW_URL" in
    *legacy*) ;;
    *)        TICKET=${NEW_URL##*s/}; TICKET=${TICKET%/} ;;
  esac
}

if test -z "$1"; then
  echo "usage: artifact2ticket.sh <artifact number>"
  exit 2
fi

get_ticket $AID_PATCH $1

if test -n "$TICKET"; then
  echo $1$'\t'"#"$TICKET
  exit 0
fi

get_ticket $AID_BUG $1

if test -n "$TICKET"; then
  echo $1$'\t'"#"$TICKET
  exit 0
fi

get_ticket $AID_FEATURE $1

if test -n "$TICKET"; then
  echo $1$'\t'"#"$TICKET
  exit 0
fi

echo "Warning: artifact $1 not found" 1>&2
exit 1
