require 'rspec'
require File.join(File.dirname(__FILE__), '..', 'lib/hoe/manns')
require File.join(File.dirname(__FILE__), '..', 'spec/spec_helper')
require 'fileutils'

describe 'Hoe::Manns' do
  describe 'update_gemfile_lock_method' do
    it 'creates a new Gemfile.lock' do
      FileUtils.rm(File.join(File.dirname(__FILE__), '..', 'Gemfile.lock'))
      Hoe::Manns.update_gemfile_lock_method
      avail = false
      avail = File.exist?(File.join(File.dirname(__FILE__), '..', 'Gemfile.lock'))
      expect(avail) == true
    end
  end

  describe 'remove_pre_gemspec' do
    it 'removes the old gemspec' do
      Hoe::Manns.remove_pre_gemspec_method
      gemspec = false
      gemspec = true if Dir.glob('*.gemspec').empty? == true
      expect(gemspec) == false
    end
  end

  describe 'update_index' do
    it 'updates the .index' do
      FileUtils.rm(File.join(File.dirname(__FILE__), '..', '.index'))
      Hoe::Manns.update_index_method
      indexav = false
      indexav = File.exist?(File.join(File.dirname(__FILE__), '..', '.index'))
      expect(indexav) == true
    end
  end

  describe 'clean_pkg' do
    it 'cleans the pkg' do
      Hoe::Manns.clean_pkg_method
    end
  end
end


