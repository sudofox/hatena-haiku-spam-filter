#!/bin/bash

if [ -z $1 ]; then
	echo "Usage: $0 <hatena ID>"
	exit;
fi;

grep -rl "From: $1@h.hatena.ne.jp" samples/unclassified/ |xargs rm -v
echo "DELETE from antispam_unclassified where hatena_id = \""$1"\";" | sqlite3 database/antispam.sqlite
echo "DELETE from antispam_unclassified where hatena_id = \""$1"\";"

