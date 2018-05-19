#!/bin/bash

(>&2 echo "[INFO] This list should be verified before reporting.")
DBRESULTS=$(echo 'select distinct(hatena_id) from antispam_unclassified where spam_check_judgement =1;' | sqlite3 database/antispam.sqlite |sort|uniq)

#echo "$DBRESULTS"

comm -13 <(cat user_lists/blacklist.txt|sort|uniq) <(echo "$DBRESULTS")
