#!/bin/sh
set -x

# Force user and group because lighttpd runs as webdav
USERNAME=webdav
GROUP=webdav

# Only allow read access by default
READWRITE=${READWRITE:=false}

# Add user if it does not exist
if ! id -u "${USERNAME}" >/dev/null 2>&1; then
	addgroup -g ${PGID:=1000} ${GROUP}
	adduser -G ${GROUP} -D -H -u ${PUID:=1000} ${USERNAME}
fi

chown webdav /var/log/lighttpd

if [ -n "$WHITELIST" ]; then
	sed -i "s/WHITELIST/${WHITELIST}/" /etc/lighttpd/webdav.conf
fi

if [ "$READWRITE" == "true" ]; then
	sed -i "s/is-readonly = \"\\w*\"/is-readonly = \"disable\"/" /etc/lighttpd/webdav.conf
else
	sed -i "s/is-readonly = \"\\w*\"/is-readonly = \"enable\"/" /etc/lighttpd/webdav.conf
fi

if [ "$BROWSABLE" == "true" ]; then                                                           
        sed -i "s/dir-listing.activate = \"\\w*\"/dir-listing.activate = \"enable\"/" /etc/lighttpd/webdav.conf
else                                                                                          
	sed -i "s/dir-listing.activate = \"\\w*\"/dir-listing.activate = \"disable\"/" /etc/lighttpd/webdav.conf       
fi                                                                                            

if [ ! -f /config/htpasswd ]; then
	cp /etc/lighttpd/htpasswd /config/htpasswd
fi

if [ ! -f /config/webdav.conf ]; then
	cp /etc/lighttpd/webdav.conf /config/webdav.conf
fi

lighttpd -f /etc/lighttpd/lighttpd.conf

# Hang on a bit while the server starts
sleep 5

tail -f /var/log/lighttpd/*.log
