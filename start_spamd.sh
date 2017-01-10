#!/bin/bash

# Start spamd
#HOME=`pwd` spamd -i localhost:31999 --local --allow-tell --virtual-config-dir=`pwd`
#spamd -i localhost:31999 --local --allow-tell --virtual-config-dir=`pwd`/.spamassassin --username=`whoami`
HOME=`pwd` spamd -i localhost:31999 --local --allow-tell -H $PWD -u $USER --virtual-config-dir .spamassassin --user-config .spamassassin
