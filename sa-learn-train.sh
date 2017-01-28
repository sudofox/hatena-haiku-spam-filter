#!/bin/bash
# SpamAssassin Bayesian Filter training on collected samples.

sa-learn --spam samples/spam/*.txt
sa-learn --ham samples/ham/*.txt
