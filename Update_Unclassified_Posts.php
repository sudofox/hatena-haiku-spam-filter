#!/usr/bin/env php
<?php

require_once dirname(__FILE__) . "/config.php";

$db = new SQLite3(DATABASE_PATH);

$format["blue"]    = exec("tput setaf 4");
$format["yellow"]  = exec("tput setaf 3");
$format["green"]   = exec("tput setaf 2");
$format["red"]     = exec("tput setaf 1");
$format["bold"]    = exec("tput bold");
$format["dim"]     = exec("tput dim");
$format["reset"]   = exec("tput sgr0");

// Using the Hatena Haiku API, fetches recent posts and stores them in an email-like format.
// This script runs automatically and stores posts in samples/unclassified to be processed later manually.
// It also runs it through SpamAssassin and stores the score at time of check in the database.
//begin renderEmail

function renderEmail($entry) {

	// Render Haiku entry in email format

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
Message-Id: <{$timestampFormats[1]}.{$entry["id"]}@sudofox.spam.filter.lightni.ng>
X-Hatena-Fan-Count: {$entry["user"]["followers_count"]}
Date: {$timestampFormats[0]}

{$entry["text"]}

EOD;
	return $email;
}
// end renderEmail

// begin querySpamAssassin

function querySpamAssassin($message) {

	$results = array(); // returned at end of function

	$check = shell_exec("echo " .base64_encode($message) ."|base64 --decode | spamc -R --port " . SPAMD_PORT);
	$check = explode(PHP_EOL, trim($check));
	$score = explode("/",$check[0]);

	$results["score"]		= $score[0];
	$results["threshold"]		= $score[1];
	$results["judgement"]		= ($score[0] > $score[1]);
	$results["score_details"]	= implode("\n", array_slice($check,8));


	return $results;
}

// end querySpamAssassin
echo $format["blue"] . "[INFO] Fetching recent posts...if a post has already been classified, it will be skipped.\n". $format["reset"];

$public_timeline = json_decode(file_get_contents("http://h.hatena.ne.jp/api/statuses/public_timeline.json?count=200") , true);
$post_count = count($public_timeline);

foreach($public_timeline as $key => $entry) {

	$filename = strtotime($entry["created_at"]) . "." . $entry["id"] . "." . "_sudofox.spam.filter.lightni.ng_.txt";

	// We will soon be reworking the manual classification to pull data from the unclassified table
	// and then redesign the whole thing to just use one table - as it is right now, by-id on the
	// web interface uses the 'unclassified' table which has only automatic data (with bayes influenced by
	// the manual classification I've been doing every few hours)

	if (file_exists("samples/unclassified/$filename")) {
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

EOD;
if ($entry["user"]["followers_count"] < 5) {
	$info .= $format["red"];
} elseif ($entry["user"]["followers_count"] > 5 && $entry["user"]["followers_count"] < 100) {
	$info .= $format["yellow"];
} else { // more than 100
	$info .= $format["green"];
}
$info .= <<<EOD
Followers:	{$entry["user"]["followers_count"]}

EOD;
$info .= $format["reset"];
$info .= <<<EOD
Post ID:	{$entry["id"]}

Post Body:	{$entry["text"]}
================
EOD;
	echo $info . "\n";
	echo "Entry $key of $post_count\n";


	$emailBody = renderEmail($entry);
	$SpamAssassinResults = querySpamAssassin($emailBody);
	print_r($SpamAssassinResults);
	/*

Array
(
    [score] => 13.5
    [threshold] => 5.0
    [judgement] => 1
    [score_details] =>  pts rule name              description
---- ---------------------- --------------------------------------------------
 4.0 BAYES_99               BODY: Bayes spam probability is 99 to 100%
                            [score: 1.0000]
 1.0 SUDO_HATENA_ZERO_FANS  User has no fans -- may be spammer
 4.0 BAYES_999              BODY: Bayes spam probability is 99.9 to 100%
                            [score: 1.0000]
 2.0 TVD_SPACE_RATIO        No description available.
 2.5 TVD_SPACE_RATIO_MINFP  Space ratio
)

*/

	$addSample = $db->prepare("INSERT INTO antispam_unclassified (post_id, timestamp, hatena_id, source, keyword, body, follower_count, spam_check_score_details, spam_check_score, spam_check_threshold, spam_check_judgement) values (:post_id, :timestamp, :hatena_id, :source, :keyword, :body, :follower_count, :spam_check_score_details, :spam_check_score, :spam_check_threshold, :spam_check_judgement)");
	$addSample->bindValue(':post_id',			$entry["id"]);
	$addSample->bindValue(':timestamp',			strtotime($entry["created_at"]));
	$addSample->bindValue(':hatena_id',			$entry["user"]["id"]);
	$addSample->bindValue(':source',			$entry["source"]);
	$addSample->bindValue(':keyword',			$entry["keyword"]);
	$addSample->bindValue(':body',				$entry["text"]);
	$addSample->bindValue(':follower_count',		$entry["user"]["followers_count"]);
	$addSample->bindValue(':spam_check_score_details', 	$SpamAssassinResults["score_details"]);
	$addSample->bindValue(':spam_check_score',		$SpamAssassinResults["score"]);
	$addSample->bindValue(':spam_check_threshold',		$SpamAssassinResults["threshold"]);
	$addSample->bindValue(':spam_check_judgement',	 	$SpamAssassinResults["judgement"] ? 1: 0);
	$results = $addSample->execute();

	$storePath = "samples/unclassified/$filename";
	file_put_contents($storePath, $emailBody);
}

echo "All done!\n";
