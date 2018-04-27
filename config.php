<?php

// Config file for Hatena Haiku Anti-Spam filter

define("ANTISPAMROOT", dirname(__FILE__)); // this will have no trailing slash

define("DATABASE_PATH", ANTISPAMROOT . "/database/antispam.sqlite");

define("SPAMD_PORT", 31999);
