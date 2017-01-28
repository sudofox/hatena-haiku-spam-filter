# hatena-haiku-spam-filter (はてなハイクスパムフィルタ)

Hatena Haiku has a lot of spam, but I believe that, with some work and some custom rules, SpamAssassin can be retooled to detect the spam with a high level of accuracy.

Requires spamassassin (yum install spamassassin) and PHP (for now)

Along with SpamAssassin classification, I also believe that individual users and their history can also be further factored into the classification (outside of SpamAssassin).

This may take some data gathering over time, but will be well-worth the effort.

## Interactive post classifier

![](https://raw.githubusercontent.com/sudofox/hatena-haiku-spam-filter/master/media/HRi4UJc.gif)

## Bayesian filter 

Train it with ./sa-learn-train.sh

## Local spamd

NOTE: Currently being run under a non-privileged user on a CentOS 7 box. ~/.spamassassin is symlinked to the .spamassassin folder inside the repo as I have not yet figured out how to properly isolate spamd's user prefs to this folder.

Start in a screen session or something with ./start_spamd.sh


TODO:

- Build a database of users by Hatena ID and store a history of their processed entries and associated scores to help avoid one-off filter misses
- Add custom rules for repeated links in the body
- Add custom rule for Live Streaming spam
- There is some Japanese spam, but not much. It can be found by checking for very long bodies with Japanese in them, often with long lists of similarly phrases.
- Add custom rule to apply negative points for a user with fans -- users with fans are very unlikely to be spammers! A threshold of 2-3 fans should be enough for now...spam bots rarely have fans
- Get everything into one self-contained folder (fix arguments for local spamd instance, create config with custom rules contained within)
