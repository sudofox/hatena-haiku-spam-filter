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
