#!/bin/bash
# SpamAssassin Bayesian Filter training on collected samples.

sa-learn --spam samples/spam/*
sa-learn --ham samples/ham/*

