FROM arm32v7/alpine:latest
MAINTAINER Dan Parker

ENV PACKAGE_LIST="lighttpd lighttpd-mod_webdav lighttpd-mod_auth openssl" \
    REFRESHED_AT='2016-12-26'

RUN apk add --no-cache ${PACKAGE_LIST}

VOLUME [ "/config", "/webdav" ]

ADD files/* /etc/lighttpd/
ADD ./entrypoint.sh /entrypoint.sh

EXPOSE 443

RUN chmod u+x  /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
