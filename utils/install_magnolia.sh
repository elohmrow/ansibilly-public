#!/bin/bash

# [0] optional: get tomcat.  could also get most recent version, as in [1],
#     or, use a pre-installed tomcat.  this seems clean for now.
./get_tomcat.sh

# [1] get the most recent Magnolia:
./get_most_recent_magnolia.sh

# [2] get the most recent author training code:
if [ -d training-author-project ]; then rm -rf training-author-project; fi
git clone ssh://git@git.magnolia-cms.com/training/training-author-project.git

# [3] fiddle the war:
./fiddle_the_war.sh

# [4] move the war file(s) to apache's webapps dir:
cp magnoliaAuthor.war magnoliaPublic.war
mv *.war apache-tomcat-8.5.20/webapps/ 

# [5] add bootstraps:

# [6] start tomcat, which will start magnolia:
./apache-tomcat-8.5.20/bin/catalina.sh start && tail -f apache-tomcat-8.5.20/logs/catalina.out
