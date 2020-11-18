#!/bin/sh

mongod --fork --logpath=/data/db/log.log 
nohup ./../../ckb_v0.38.0-rc1_x86_64-unknown-linux-gnu/ckb run -C ../../testnet/ &
sleep 5
nohup ./../../ckb-indexer -s ../../indexer_tmp/ckb-indexer-test/ &
nohup ruby GPC.rb start &
sleep 3
/bin/bash