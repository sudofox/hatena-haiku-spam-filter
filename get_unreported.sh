#!/bin/bash

(>&2 echo "[INFO] This list should be verified before reporting.")
#DBRESULTS=$(echo 'select distinct(hatena_id) from antispam_unclassified where spam_check_judgement =1;' | sqlite3 database/antispam.sqlite |sort|uniq)
DBRESULTS=$(echo 'select hatena_id from antispam_unclassified where spam_check_judgement =1 group by hatena_id having count(*) > 5;' |sqlite3 database/antispam.sqlite |sort|uniq)
#echo "$DBRESULTS"

# Users not in whitelist or blacklist...
comm -13 <(cat user_lists/whitelist.txt|sort|uniq) <(comm -13 <(cat user_lists/blacklist.txt|sort|uniq) <(echo "$DBRESULTS"))
