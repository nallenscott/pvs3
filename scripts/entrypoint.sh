#!/bin/sh

ACTION="$1"

# empty action
if [ -z "$ACTION" ]; then
  echo "No action specified!"
  exit 1
fi

# check action
if [ ! -f "/pvs3/actions/$ACTION.sh" ]; then
  echo "Invalid action: $ACTION"
  exit 1
fi

# run action
/pvs3/actions/$ACTION.sh
