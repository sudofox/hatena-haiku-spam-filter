#!/bin/bash

awk '{print "blacklist_from "$1"@h.hatena.ne.jp"}' user_lists/blacklist.txt |sort|uniq > .spamassassin/user_black_and_white_lists

awk '{print "whitelist_from "$1"@h.hatena.ne.jp"}' user_lists/whitelist.txt |sort|uniq >> .spamassassin/user_black_and_white_lists
