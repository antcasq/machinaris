#!/bin/env bash
#
# Launch WebUI in DEV mode from within container.  
# NOT IN GIT.  Runs in foreground of shell.
#

echo 'Starting Machinaris...'
mkdir -p /root/.chia/machinaris/logs
cd /machinaris-dev

/chia-blockchain/venv/bin/gunicorn \
    --reload \
    --bind 0.0.0.0:8926 \
    --timeout 90 \
    --log-level=debug \
    --workers=2 \
    web:app