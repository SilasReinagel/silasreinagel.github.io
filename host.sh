#!/bin/bash
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export GEM_HOME=~/.gem/ruby/2.6.0
export PATH="$GEM_HOME/bin:$PATH"
bundle exec jekyll serve --port 6457 --watch &
