# -*- ruby -*-
# Copyright (C) 2013-2018 Sascha Manns <Sascha.Manns@outlook.de>
# Release:
# Pre-release:
#* update docs
#* Update copyright years if needed, in the following paths:
#  + lib/*
#* Check version in lib/hoe-manns.rb
#* Update History.rdoc & NEWS
#* git:manifest
#* bundler:gemfile
#* bundler:gemfile_lock
# x64-mingw32
# x64-mswin32
# x86-mingw32
# x86-mswin32
# ruby
# x86_64-linux
#* bundle_audit:run
#* git -a -m "Anything"
#* git tag x.x.x

# Release:
#* Create Release in Github
#* rake release
#* send_email
#* clean_pkg

# Post-release:
#* Bump version
#* Add new Milestone on Github

# Dependencies
require 'rubygems'
require 'hoe'

Hoe.plugin :bundler
Hoe.plugin :rdoc
Hoe.plugin :rubygems
Hoe.plugin :version


###########################################DEVELOPING ZONE##############################################################
# rubocop:disable Metrics/LineLength
Hoe.spec 'hoe-manns' do
  developer('Sascha Manns', 'Sascha.Manns@outlook.de')
  license 'GPL-3.0' # this should match the license in the README
  require_ruby_version '>= 2.3.0'

  dependency 'rainbow', '~> 3.0'
  dependency 'bundler-audit', '~> 0.6'

  extra_dev_deps << ['hoe-bundler', '~> 1.4']
  extra_dev_deps << ['hoe-rubygems', '~> 1.0']
  extra_dev_deps << ['hoe-version', '~> 1.2']
  extra_dev_deps << ['rdoc', '~> 6.0']
  extra_dev_deps << ['rspec', '~> 3.8']
  extra_dev_deps << ['simplecov', '~> 0.16']
  extra_dev_deps << ['simplecov-cobertura', '~> 1.3']

  self.history_file = 'History.rdoc'
  self.readme_file = 'README.rdoc'
  self.extra_rdoc_files = FileList['*.rdoc'].to_a
  self.post_install_message = 'Please file bugreports on: https://dev.azure.com/saigkill/hoe-manns/_workitems'
end

##################################################SETUP ZONE############################################################



# vim: syntax=ruby

