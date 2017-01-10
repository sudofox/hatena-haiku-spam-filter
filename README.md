# hatena-haiku-spam-filter (はてなハイクスパムフィルタ)

Requires spamassassin (yum install spamassassin) and PHP (for now)

NOTE: Currently being run under a non-privileged user on a CentOS 7 box. ~/.spamassassin is symlinked to the .spamassassin folder inside the repo as I have not yet figured out how to properly isolate spamd's user prefs to this folder.

Hatena Haiku has a lot of spam, but I believe that, with some work and some custom rules, SpamAssassin can be retooled to detect the spam with a high level of accuracy.

Along with SpamAssassin classification, I also believe that individual users and their history can also be further factored into the classification (outside of SpamAssassin).

This may take some data gathering over time, but will be well-worth the effort.
