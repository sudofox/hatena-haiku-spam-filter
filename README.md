# hatena-haiku-spam-filter (はてなハイクスパムフィルタ)

Hatena Haiku has a lot of spam, but I believe that, with some work and some custom rules, SpamAssassin can be retooled to detect the spam with a high level of accuracy.

Requires spamassassin (yum install spamassassin) and PHP (for now)

Along with SpamAssassin classification, I also believe that individual users and their history can also be further factored into the classification (outside of SpamAssassin).

This may take some data gathering over time, but will be well-worth the effort.

## Interactive post classifier

![](https://raw.githubusercontent.com/sudofox/hatena-haiku-spam-filter/master/media/HRi4UJc.gif)

## Bayesian filter 

Train it with ./sa-learn-train.sh

## user_lists folder

Inside this folder we will have two text files in which we can place a list of Hatena IDs to manually whitelist or blacklist them.

```
user_lists/whitelist.txt
user_lists/blacklist.txt
```

This will be integrated into both the Interactive Classifier, and soon, into a utility that builds the user_prefs file from a template.
This will allow us to generate the file without manually going in and editing it. In this case, we can use whitelist_from and blacklist_from.


## Local spamd

NOTE: Currently being run under a non-privileged user on a CentOS 7 box. 

Start in a screen session with ./start_spamd.sh

We have a custom formatted local.cf which I will add to the repository soon

TODO:

- Redesign and possibly merge Unclassified (misleading name, as it is the stuff that has been automatically classified) with the manually classified items database
	- We want to be able to supply immediate data no matter whether I have gone through the recent entries or not to classify them)
- Build a database of users by Hatena ID and store a history of their processed entries and associated scores to help avoid one-off filter misses
- Possibly move away from SQLite or make it work with both MySQL and SQLite.

