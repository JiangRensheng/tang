#!/bin/sh

export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
export PATH=/opt/tang:$PATH

/opt/tang/tangd-keygen /var/db/tang 
/opt/tang/tangd-update /var/db/tang /var/cache/tang
/opt/tang/tangd /var/cache/tang

