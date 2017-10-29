---
layout: post
title:  "New version 2.1.0 available"
date:   2017-10-28 17:24:09 +0200
categories: update
---
A new release of hoe-manns are now available.

# What happend?

5 minor enhancements

* HM-9: Split module into two seperate modules
* HM-10: Remove run_after_release
* HM-11: Remove system('git add recipes/recipe.rb') if File.exist?('recipes/recipe.rb')
* HM-13: Add more tests
* Added task 'rake bundler:gemfile install'
* Changed publican to daps docbook managing

## How to get it?
Just use "gem install hoe-manns".