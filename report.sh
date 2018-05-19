#!/bin/bash

if [ ! -f ./credentials.sh ]; then
	echo "Error: could not open credentials.sh."
	exit 1;
fi

source ./credentials.sh

if [ -z $1 ]; then
	echo Usage: $0 '<hatena-id>';
	exit;
fi
USER=$1

# check if user has already been banned
# (using response code - this is another example of where a 404ing API response is rewritten to an actual HTML page...not very good design, uses more of their CPU)

if [[ $(curl -sI http://h.hatena.ne.jp/api/statuses/friends/$USER.json |grep "HTTP/1.1 404 Not Found"|wc -l) == "1" ]]; then
	echo "User has already been banned."
	exit;
fi;

curl 'https://www.hatena.ne.jp/faq/report' \
-H'Pragma: no-cache' \
-H'Cache-Control: no-cache' \
-H'Origin: https://www.hatena.ne.jp' \
-H'Upgrade-Insecure-Requests: 1' \
-H'Content-Type: application/x-www-form-urlencoded' \
-H'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.139 Safari/537.36' \
-H'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8' \
-H'Referer: https://www.hatena.ne.jp/faq/report' \
-H'Accept-Language: en-US,en;q=0.9' \
-H'Cookie: rk='"$HATENA_COOKIE"';' \
--data 'location=http%3A%2F%2Fh.hatena.ne.jp%2F'"$USER"'%2F&c=190190366671307580&report_type=report.type.spam&content=https%3A%2F%2Fhaikuantispam.lightni.ng%2Fid%2F'"$USER"'+Detected+as+spammer+by+Sudofox,+please+enjoy+your+day&target_url=http%3A%2F%2Fh.hatena.ne.jp%2F'"$USER"'%2F&target_label='"$USER"'&referer=http%3A%2F%2Fh.hatena.ne.jp%2F'"$USER"'%2F&captcha_string=&target_url=http%3A%2F%2Fh.hatena.ne.jp%2F'"$USER"'%2F&target_label='"$USER"'&object_local_id=&object_data_category=&object_hash=&object_permalink_url=&post=Send+this+information'

