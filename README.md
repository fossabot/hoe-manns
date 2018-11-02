# hoe-manns

code  :: https://dev.azure.com/saigkill/hoe-manns <br />
rdoc  :: http://www.rubydoc.info/gems/hoe-manns <br />
docs  :: https://dev.azure.com/saigkill/hoe-manns/_wiki <br />
bugs  & feature requests:: https://dev.azure.com/saigkill/hoe-manns/_workitems <br />
mailing list :: https://groups.google.com/forum/#!forum/saigkills-hoe-plugins <br />
openhub statistics :: https://www.openhub.net/p/hoe-manns <br />
authors blog :: https://saigkillsbacktrace.azurewebsites.net/ <br />
min_rubyver :: 2.3.0

| What | Status |
|-------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|last public version | [![Last Version](https://badge.fury.io/rb/hoe-manns.png)](http://rubygems.org/gems/hoe-manns) |
|downloads latest | [![Downloads latest](https://img.shields.io/gem/dtv/hoe-manns.svg)](http://rubygems.org/gems/hoe-manns)  |
|downloads all | [![Downloads all](https://img.shields.io/gem/dt/hoe-manns.svg)](http://rubygems.org/gems/hoe-manns) |
|continuous integration | [![Build Status](https://dev.azure.com/saigkill/hoe-manns/_apis/build/status/hoe-manns-CI)](https://dev.azure.com/saigkill/hoe-manns/_build/latest?definitionId=3) |
|code quality | [![Code Quality](https://api.codeclimate.com/v1/badges/009b795034d7c698c74f/maintainability)](https://codeclimate.com/github/saigkill/hoe-manns/maintainability) |
|security | [![Security](https://hakiri.io/github/saigkill/hoe-manns/master.svg)](https://hakiri.io/github/saigkill/hoe-manns/master/shield) |
|documentation quality | [![Documentation Quality](https://inch-ci.org/github/saigkill/hoe-manns.svg?branch=master)](https://inch-ci.org/github/saigkill/hoe-manns) |

## DESCRIPTION:

hoe-manns is a small collection of my personal used rake tasks for using with hoe. Actually it includes that tasks:

* bundler:gemfile_lock
* bundle_audit:*
* clean_pkg
* copy_master
* remove_pre_gemspec
* run_before_release
* run_after_release

The History.rdoc contains a detailed description of what has changed.

hoe-manns is released under the GPL3 License, see the file 'LICENSE.md' for more information.

## FEATURES:

* Updates the Gemfile.lock
* Removes the old *.gemspec created in test cases
* copies your manuals to your docpath.
* runs the rake tasks before release: git:manifest, bundler:gemfile, update_gemfile_lock, remove_pre_gemspec, bundler_audit:run and copy_mirror.
* runs after release: send_email.
* Cleans up the pkg dir
* provides bundler_audit tasks

## REQUIREMENTS:

* rake
* hoe
* bundler-audit

## INSTALL:

The installation is very easy.

    gem install hoe-manns

## SYNOPSIS:

Use in your Rakefile:

    Hoe.plugin :manns

    Hoe.spec 'your project' do
    ...
    end

Also add hoe-manns to your requirements and recreate your Gemfile.

## DEVELOPERS:

After checking out the source, run:

    $ rake newb

This task will install any missing dependencies, run the tests/specs, and generate the RDoc.
Also you can read the MAINTENANCE.md and CONTRIBUTING.md for more information.

## ISSUE TRACKING:

* Add ideas on: https://dev.azure.com/saigkill/hoe-manns/_workitems
