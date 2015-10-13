This is a manual for hoe-manns. In this collection i excluded some code which i using all around my projects. But what exactly happens?

* update_gemfile_lock does a simple "bundler update" which recreates the Gemfile.lock
* remove_pre_gemspec removes the gemfile what could be present from earlier tests
* update_workspace checks the stuff in. So you can make rake release on a clean base
* update_index runs a "index --using VERSION Index.yml". If you are using indexer (Metadata creator) from Rubyworks
you can use that task for running an update. You have to update the version number in the VERSION file manually!
Actually i haven't any idea, how to do that automatically.
* clean_pkg cleans up your pkg directory
* update_manuals copies the manual folder to your docpath. The task asks you for your project name. The docpath will be set in USER/.hoe-manns/hoe-manns.cfg. Let me say you have a project "dummy" and you place your docs in /your/path/docs the manuals will be shown under /your/path/docs/dummy/. There you have your index.html and the resources.
* run_before_release runs the Rake tasks: "git-manifest", "bundler:gemfile", "update_gemfile_lock", "update_index",
"remove_pre_gemspec" and "update_workspace" before the release.
* run_after_release runs the Rake tasks "send_email" and "version:bump" after release.
* bundler_audit:run updates the database from vulnerabilities and does a check
* update_workspace adds the workspace (Manifest, Gemfile, Rakefile, History, Readme, bin/*, data/*, etc/*, lib/*, and test/* to git and does a commit.
* copy_mirror_method copies the changes to ../your-projectname-github).
* creates deb & rpm packages from gem
* deploys packages to bintray

A deeper insight is possible there: [Behind the scene](behind-the-scene).

The APIDocs are placed there: http://www.rubydoc.info/gems/hoe-manns.

> This Gem was programmed and tested for Linux systems. If anyone would like to make the methods also fit for other OS, i'm happy about Pull requests.