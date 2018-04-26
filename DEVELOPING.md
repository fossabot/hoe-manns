## COOL HACKS

* Open a bug report on https://github.com/saigkill/hoe-manns/issues
* Please use the -u flag when generating the patch as it makes the patch
  more readable.
* Write a good explanation of what the patch does.
* It is better to use git format-patch command: git format-patch HEAD^

## MAINTENANCE POLICY

I'm following the Semantic Versioning for its releases: (Major).(Minor).(Patch).

 * Major version: Whenever there is something significant or any backward
   incompatible changes.
 * Minor version: When new, backward compatible functionality is introduced a
   minor feature is introduced, or when a set of smaller features is rolled out.
 * Patch number: When backward compatible bug fixes are introduced that fix
   incorrect behavior.
 * The current stable release will receive security patches and bug fixes
   (eg. 5.0 -> 5.0.1).
 * Feature releases will mark the next supported stable release where the minor
   version is increased numerically by increments of one (eg. 5.0 -> 5.1).

I encourage everyone to run the latest stable release to ensure that you can
easily upgrade to the most secure and feature-rich experience. In order to
make sure you can easily run the most recent stable release, we are working
hard to keep the update process simple and reliable.

## STRUCTURE

### BRANCHES

#### `master` BRANCH
The master branch is the current edge of development.

#### `X.X` BRANCH
The X.X branch is the last stable branch. It will be used for tarballs.

#### PULL REQUESTS
If you want to merge your branch with the trunk, send a pull request.

Please base all Merge requests off the `master` branch. Merges to
`X.X` only occur through the `master` branch.
