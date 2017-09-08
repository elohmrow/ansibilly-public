#!/bin/bash

# create a temporary directory with a unique name:
dir=$(date +%s)
mkdir $dir

# move the magnolia war file into that temporary directory:
cp magnoliaAuthor.war $dir
# ^ cp for testing ... mv is better later

# enter the temporary directory to do some work on the war file:
cd $dir

# unpackage the war file:
jar xf magnoliaAuthor.war

# remove the war file:
rm -f magnoliaAuthor.war

# edit magnolia.properties to point to the author training light modules:
echo "magnolia.resources.dir=/home/ec2-user/training-author-project/light-modules" >> WEB-INF/config/default/magnolia.properties
# ^ this could be paramterized instead of hardcoded
# ^ alternatively, sed the line, but, order of read properties should mean this is OK

# edit magnolia.properties to auto-install the modules:
echo "magnolia.update.auto=true" >> WEB-INF/config/default/magnolia.properties

# add bootstraps:
cp /home/ec2-user/author-bootstraps-1.0-SNAPSHOT.jar WEB-INF/lib/ 
# ^ change superuser password, disable common users, add training user, #add license
#cp /home/ec2-user/config.modules.enterprise.license.xml WEB-INF/bootstrap/common/ 

# re-package the war file:
jar cf magnoliaAuthor.war *

# back out of the temporary directory, get the re-packaged war file, remove the temporary directory:
mv magnoliaAuthor.war ..
cd ..
rm -rf $dir
