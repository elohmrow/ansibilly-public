#!/bin/bash

# get the code we need to build the magnolis instances (could do differently):
git clone ssh://git@git.magnolia-cms.com/training/training-author-instances-creation.git

# get the utility scripts we need for this part:
cp training-author-instances-creation/utils/* .

# do some cleanup (not really necessary):
rm -rf training-author-instances-creation README

# now actually run everything (see the docs, yo!):
./install_magnolia.sh 

# after install_magnolia runs, we have a bag o' stuff we no longer need ... clean it up:
rm -rf author-bootstraps-1.0-SNAPSHOT.jar fiddle_the_war.sh get_most_recent_magnolia.sh get_tomcat.sh install_magnolia.sh training-author-instances-creation

