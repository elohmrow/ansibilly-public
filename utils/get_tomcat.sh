#!/bin/bash

# could parameterize this, instead of using hardcoded value:
if [ -d apache-tomcat-8.5.20 ]; then rm -rf apache-tomcat-8.5.20; fi

wget -q http://www.pirbot.com/mirrors/apache/tomcat/tomcat-8/v8.5.20/bin/apache-tomcat-8.5.20.tar.gz
tar zxf apache-tomcat-8.5.20.tar.gz
rm -f apache-tomcat-8.5.20.tar.gz
