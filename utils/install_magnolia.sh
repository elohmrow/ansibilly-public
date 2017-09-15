#!/bin/bash

logger "=================================================="
logger "========== starting install_magnolia.sh =========="
logger "=================================================="
# [0] optional: get tomcat.  could also get most recent version, as in [1],
#     or, use a pre-installed tomcat.  this seems clean for now.
./get_tomcat.sh
logger "======================================"
logger "========== installed tomcat =========="
logger "======================================"

# [1] get the most recent Magnolia:
./get_most_recent_magnolia.sh
logger "=================================="
logger "========== got magnolia =========="
logger "=================================="

# [2] get the most recent author training code:
if [ -d training-author-project ]; then rm -rf training-author-project; fi
git clone ssh://git@git.magnolia-cms.com/training/training-author-project.git
logger "================================================"
logger "========== got light modules from git =========="
logger "================================================"

# [3] fiddle the war:
./fiddle_the_war.sh
logger "====================================================="
logger "========== modified the magnolia war files =========="
logger "====================================================="

# [4] move the war file(s) to apache's webapps dir:
cp magnoliaAuthor.war magnoliaPublic.war
mv *.war apache-tomcat-8.5.20/webapps/ 
logger "=================================================="
logger "========== moved the magnolia war files =========="
logger "=================================================="

# [5] start tomcat, which will start magnolia:
#./apache-tomcat-8.5.20/bin/catalina.sh start && tail -f apache-tomcat-8.5.20/logs/catalina.out
nohup ./apache-tomcat-8.5.20/bin/catalina.sh start &
logger "===================================="
logger "========== started tomcat =========="
logger "===================================="
