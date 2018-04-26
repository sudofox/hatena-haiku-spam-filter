#!/bin/bash

# Start spamd
HOME=`pwd` spamd -i localhost:31999 --local --allow-tell -H $PWD -u $USER --virtual-config-dir .spamassassin --user-config .spamassassin
