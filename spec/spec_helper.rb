require 'coveralls'
require 'simplecov'
require 'fileutils'
require 'rake'
Coveralls.wear!

SimpleCov.formatter = Coveralls::SimpleCov::Formatter
SimpleCov.start do
  add_filter '.yardoc'
  add_filter 'config'
  add_filter 'doc'
  add_filter 'manual'
  add_filter 'pkg'
  add_filter 'vendor'
end
