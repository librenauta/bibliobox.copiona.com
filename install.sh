#!/bin/bash
bundle install --path=~/.gem
bundle binstub jekyll
./bin/jekyll build
./bin/jekyll serve
