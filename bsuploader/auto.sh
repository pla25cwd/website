#!/bin/bash
cd /media/sda/bsuploader
source ./venv/bin/activate
screen -dmS uploader gunicorn --keyfile /etc/letsencrypt/live/gringpartei.ch/privkey.pem --certfile /etc/letsencrypt/live/gringpartei.ch/cert.pem --ca-certs /etc/letsencrypt/live/gringpartei.ch/chain.pem -b 0.0.0.0:5000 api:app
