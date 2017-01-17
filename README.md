# hatena-haiku-spam-filter



NOTE: Currently being run under a non-privileged user on a CentOS 7 box. ~/.spamassassin is symlinked to the .spamassassin folder inside the repo as I have not yet figured out how to properly isolate spamd's user prefs to this folder.

Hatena Haiku has a lot of spam, but I believe that, with some work and some custom rules, SpamAssassin can be retooled to detect the spam with a high level of accuracy.

Along with SpamAssassin classification, I also believe that individual users and their history can also be further factored into the classification (outside of SpamAssassin).

This may take some data gathering over time, but will be well-worth the effort.

TODO:

- Build a database of users by Hatena ID and store a history of their processed entries and associated scores to help avoid one-off filter misses
- Add custom rules for repeated links in the body
- Add custom rule for Live Streaming spam
- There is some Japanese spam, but not much. It can be found by checking for very long bodies with Japanese in them, often with long lists of similarly phrases.
- Add custom rule to apply negative points for a user with fans -- users with fans are very unlikely to be spammers! A threshold of 2-3 fans should be enough for now...spam bots rarely have fans
- Get everything into one self-contained folder (fix arguments for local spamd instance, create config with custom rules contained within)

