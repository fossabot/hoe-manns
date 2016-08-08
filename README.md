# hoe-manns Documentation

This is a manual for hoe-manns. 

In this collection i excluded some code which i using all around my projects. But what happens?
Before you start, edit your ~/.hoerc and add (example):

```
manns: 
    docpath: /home/youruser/RubymineProjects/saigkill.github.com/docs 
    develpath: /home/youruser/RubymineProjects
```

The docpath is optional if you like to use the update_manuals task. It expects to have a directory "manual/output" (created from the hoe-manualgen plugin).
The develpath is the path to your development projects. It will used by the copy_mirror and copy_wiki taks.

* update_gemfile_lock does a simple "bundler update" which recreates the Gemfile.lock
* remove_pre_gemspec removes the gemfile what could be present from earlier tests
* update_workspace checks in the stuff. So you can make rake release on a clean base
* clean_pkg cleans up your pkg directory
* update_manuals copies the manual folder to your docpath. Let me say you have a project "dummy" and you place your docs in /your/path/docs the manuals will be shown under /your/path/docs/dummy/. There you have your index.html and the resources.
* run_before_release runs the Rake tasks: "git-manifest", "bundler:gemfile", "update_gemfile_lock", "remove_pre_gemspec" and "update_workspace" before the release.
* run_after_release runs the Rake tasks "send_email" and "clean_pkg".
* bundler_audit:run updates the database from vulnerabilities and does a check
* copy_master: That method checks out the master, merges it with the develop branch and pushs it to origin/master. Then it creates a git tag with the version number and pushs all known tags to origin.

A deeper insight is possible in the next chapter. The APIDocs are placed there: [http://www.rubydoc.info/gems/hoe-manns](http://www.rubydoc.info/gems/hoe-manns).

> This Gem was programmed and tested for Linux systems. If anyone would like to make the methods also fit for other OS, i'm happy about Pull requests.


