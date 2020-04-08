#!/bin/sh

#  open_log.sh
#  FloatingHeads
#
#  Created by Robert Tolar Haining on 2/3/20.
#  Copyright © 2020 Robert Tolar Haining. All rights reserved.

LOG_PATH="/tmp/screensaver_notarized.txt"

echo "tail -f $LOG_PATH"
tail -f $LOG_PATH
