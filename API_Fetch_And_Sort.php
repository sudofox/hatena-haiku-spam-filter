<?php

// Using the Hatena Haiku API, fetches recent posts and stores them in an email-like format.

function renderEmail($entry)
{
	$timestamp = strtotime($entry["created_at"]);
	$timestampFormats[0] = strftime("%a, %d %b %Y %T %z (%Z)", $timestamp);
	$timestampFormats[1] = strftime("%Y%I%d%H%M%S", $timestamp);
$email = <<<EOD
Delivered-To: site@h.hatena.ne.jp
Received: by sudofox.spam.filter.lightni.ng (Sudofix)
        id {$entry["id"]}; {$timestampFormats[0]}
From: {$entry["user"]["id"]}@h.hatena.ne.jp ({$entry["user"]["name"]})
To: site@h.hatena.ne.jp
Subject: {$entry["keyword"]}
Content-Type: text/plain; charset=UTF-8
Auto-Submitted: auto-generated
Message-Id: <{$timestampFormats[1]}.{$entry["id"]}@sudofox.spam.filter.lightni.ng>
Date: {$timestampFormats[0]}

{$entry["text"]}
EOD;
	return $email;
}

$public_timeline = json_decode(file_get_contents("http://h.hatena.ne.jp/api/statuses/public_timeline.json") , true);

foreach($public_timeline as $key => $entry) {
	$filename = strtotime($entry["created_at"]) . "." . $entry["id"] . "." . "sudofox.spam.filter.lightni.ng";
	if (file_exists("samples/ham/$filename") || file_exists("samples/spam/$filename")) {
		continue;
	}

	$info = <<<EOD
== Haiku Entry ==
Keyword:	{$entry["keyword"]}
Source:		{$entry["source"]}
Hatena ID:	{$entry["user"]["id"]}

Post ID:	{$entry["id"]}

Post Body:	{$entry["text"]}
================
EOD;
	echo $info . "\n\n";
	$decision = "-";
	while (!in_array($decision, array("y","n"))) {
		$decision = readline("Is this spam? (y/n): ");
	}

	$emailBody = renderEmail($entry);
	echo $emailBody . "\n";
}
