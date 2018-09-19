#!/bin/bash
set -e
tangd-keygen /var/db/tang
tangd-update /var/db/tang /var/cache/tang

exec "$@"
