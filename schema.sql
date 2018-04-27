CREATE TABLE antispam_samples (
	post_id integer primary key,
	timestamp integer,
	hatena_id text not null,
	source text not null,
	keyword text not null,
	body text not null,
	follower_count int default 0,
	spam boolean default 0 not null check (spam in (0,1))
);

CREATE TABLE antispam_unclassified (
	post_id integer primary key,
	timestamp integer,
	hatena_id text not null,
	source text not null,
	keyword text not null,
	body text not null,
	follower_count int default 0,
	spam_check_score_details text,
	spam_check_score decimal(5,2) default 0,
	spam_check_threshold decimal(5,2) default 5,
	spam_check_judgement boolean default 0 not null check (spam_check_judgement in (0,1))
);
