#!/usr/bin/env php
<?php

require_once dirname(__FILE__) . "/config.php";

$db = new SQLite3(DATABASE_PATH);

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
X-Hatena-Fan-Count: {$entry["user"]["followers_count"]}
Date: {$timestampFormats[0]}

{$entry["text"]}
EOD;
	return $email;
}

echo "Fetching recent posts...if a post has already been classified, it will be skipped.\n";
$public_timeline = json_decode(file_get_contents("http://h.hatena.ne.jp/api/statuses/public_timeline.json?count=200") , true);
$post_count = count($public_timeline);

foreach($public_timeline as $key => $entry) {
	$filename = strtotime($entry["created_at"]) . "." . $entry["id"] . "." . "_sudofox.spam.filter.lightni.ng_.txt";
	if (file_exists("samples/ham/$filename") || file_exists("samples/spam/$filename")) {
		continue;
	}

	if (!(ctype_digit((string)$entry["id"]) && ctype_digit((string)strtotime($entry["created_at"])))) {
		error_log("Error: invalid id or creation timestamp, this is an invalid API response! (Sleeping 5)");
		sleep(5);
		continue;
	}

$info = <<<EOD
== Haiku Entry ==
Keyword:	{$entry["keyword"]}
Source:		{$entry["source"]}
Hatena ID:	{$entry["user"]["id"]}
Followers:	{$entry["user"]["followers_count"]}

Post ID:	{$entry["id"]}

Post Body:	{$entry["text"]}
================
EOD;
	echo exec("clear");
	echo $info . "\n";
	echo "Entry $key of $post_count\n";
	$decision = "";
	while (!in_array($decision, array(
		"y",
		"n"
	))) {
		$decision = readline("Is this spam? (y/n): ");
	}

	$spam = ($decision == "y");

	// Insert into database

	$addSample = $db->prepare("INSERT INTO antispam_samples (post_id, timestamp, hatena_id, source, keyword, body, spam, follower_count) values (:post_id, :timestamp, :hatena_id, :source, :keyword, :body, :spam, :follower_count)");
	$addSample->bindValue(':post_id',		$entry["id"]);
	$addSample->bindValue(':timestamp',		strtotime($entry["created_at"]));
	$addSample->bindValue(':hatena_id',		$entry["user"]["id"]);
	$addSample->bindValue(':source',		$entry["source"]);
	$addSample->bindValue(':keyword',		$entry["keyword"]);
	$addSample->bindValue(':body',			$entry["text"]);
	$addSample->bindValue(':follower_count',	$entry["user"]["followers_count"]);
	$addSample->bindValue(':spam',			$spam ? 1 : 0);
	$results = $addSample->execute();
	$emailBody = renderEmail($entry);
	echo $emailBody . "\n";
	$storePath = "samples/" . ($spam ? "sp" : "h") . "am/$filename";
	file_put_contents($storePath, $emailBody);
}

echo exec("clear");
echo "All done!\n";
