#!/bin/bash

echo "== Paste in email-style entry with headers, and then press Ctrl+D =="
spamc -R --port 31999 <(cat)
