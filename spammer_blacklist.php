<?php

if (file_exists("./user_lists/blacklist.txt")) {
	$spammer_blacklist = file("./user_lists/blacklist.txt", FILE_IGNORE_NEW_LINES);
	$spammer_blacklist = array_map('trim', $spammer_blacklist);
} else {
	$spammer_blacklist = array();
}

