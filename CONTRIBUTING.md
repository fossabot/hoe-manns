## Reporting Bugs

* Ensure the bug was not already reported, see the
  [Issue Tracker](https://dev.azure.com/saigkill/hoe-manns/_workitems) on GitHub.
* Open an issue or reference an existing one
* Assign yourself to the issue when you are working on it
* Reference the issue number (with `#NUMBER`) in your pull request

Thanks!

# IDEAS:

* Add ideas on: https://dev.azure.com/saigkill/hoe-manns/_workitems

## COOL HACKS:

* Open a bugreport on https://dev.azure.com/saigkill/hoe-manns/_workitems.
* Please use the -u flag when generating the patch as it makes the patch
  more readable.
* Write a good explanation of what the patch does.
* It is better to use git format-patch command: git format-patch HEAD^

# STRUCTURE:

## BRANCHES:

### `master` BRANCH:
The master branch is the last stable version.

### `develop` BRANCH:
The develop branch is the current edge of development.

### PULL REQUESTS:
Please base all Pullrequests off the `develop` branch. Merges to
`X.X` only occur through the `develop` branch.