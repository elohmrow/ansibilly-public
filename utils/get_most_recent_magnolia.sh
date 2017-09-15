#!/bin/bash

# this script averages about 50 seconds to run, because it actually tries to figure out what the most recent version of magnolia is, 
# by checking here: https://files.magnolia-cms.com/.  it then downloads the most recent EE Pro demo web app war.

# could add variables
# could just ask what version they want

function get_most_recent_magnolia {
	if [ -e files.html ]; then
		rm -f files.html
	fi
	
	if [ -e magnoliaAuthor.war ]; then
		rm -f magnoliaAuthor.war
	fi

	wget -q -O files.html https://files.magnolia-cms.com/

	# get the first version link from https://files.magnolia-cms.com/ ... maybe better way, but this works for now.

	MAGNOLIA_VERSION=$(grep -Po -m 1 '\d.\d.\d' files.html | uniq)

	rm -f files.html

        # this command runs a lot slower under systemd
        # default timeout for wget seems to be 900s
        # if wget times out, the systemd unit eventually fails
        # --timeout=0 means 'never timeout'
	wget -q --timeout=0 -O magnoliaAuthor.war  https://files.magnolia-cms.com/${MAGNOLIA_VERSION}/magnolia-enterprise-pro-demo-webapp-${MAGNOLIA_VERSION}.war
}
date
get_most_recent_magnolia
date
