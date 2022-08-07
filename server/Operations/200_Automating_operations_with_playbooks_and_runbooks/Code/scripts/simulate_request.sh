#!/bin/bash

ALBURL=$1
while :
do
    ab -p test.json -T application/json -c 3000 -n 60000000 -v 4 http://$ALBURL/encrypt
done