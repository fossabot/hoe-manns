---
layout: post
title:  "New version 3.0.0 available"
date:   2017-10-18 15:04:09 +0200
categories: update
---
A new release of youtube_dlhelper are now available.

# What happend?
## 6 major enhancements

### YDL#3: Fix travis
* Rework of .travis.yml. Specially usage of a static ffmpeg and a chmod of
  the youtube-dl.rb binary.

### YDL#2: Changed place of config file to XDG standard
* Added install_config task to Rakefile
* Added XDG dependency and changed place of config (lib/import_config.rb)

### YDL#1: Added manpage (Changes in Rakefile)
* Added Rake task :manpage and :manpage_register. The last one
  will be executed each time, where :setup runs.
* Added a youtube_dlhelper.xml

### General code style refactoring

### Reworked Downloader Class:
* Now it downloads directly a ogg file

### Reworked Ripper Class:
* It just checks if ogg file are accepted. Just if it is set to false,
    the program starts ffmpeg to transcode the ogg to mp3.

## How to get it?
Just use "gem install youtube_dlhelper".