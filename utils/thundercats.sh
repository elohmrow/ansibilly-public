#!/bin/bash

cd /home/ec2-user

git clone ssh://git@git.magnolia-cms.com/training/training-author-instances-creation.git

cp training-author-instances-creation/utils/* .

rm -rf training-author-instances-creation README

./install_magnolia.sh

rm -rf author-bootstraps-1.0-SNAPSHOT.jar fiddle_the_war.sh get_most_recent_magnolia.sh get_tomcat.sh install_magnolia.sh training-author-instances-creation usr_lib_systemd_system_start_magnolia_on_boot.service

./start_magnolia.sh
