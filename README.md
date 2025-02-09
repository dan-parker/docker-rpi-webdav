# Docker WebDAV with SSL image

A tiny image running [docker-alpine](https://hub.docker.com/_/alpine) Linux and [Lighttpd](https://www.lighttpd.net/).

## Usage

	docker run --restart=always -d
		-p 0.0.0.0:443:443 \
		--hostname=webdav \
		--name=webdav \
		-v /<host_directory_to_share>:/webdav \
		-v /path/to/appdata/config:/config \
		viperlord/docker-rpi-webdav

By default the WebDAV server is password protected with user `webdav` and password `vadbew` which obviously isn't really secure.
This can easily be overwritten, by creating a `config directory` on the host with an *htpasswd* file and mounting this as a volume on `/config`.

	-v /<host_config_directory>:/config

You could use an online htpasswd generator like [https://www.transip.nl/htpasswd/](https://www.transip.nl/htpasswd/) to create the password hashes when you don't have a machine with the `htpasswd` package. (**Hint**: The package is `apache2-utils`)

You can also provide a list of IP's in the form of a regular expression which are then whitelisted. See below.

## Optional environment variables

* `PUID` User ID of the lighttpd daemon account (default: 1000).
* `PGID` Group ID of the lighttpd daemon account (default: 1000).
* `WHITELIST` Regexp for a list of IP's (default: none). Example: `-e WHITELIST='192.168.1.*|172.16.1.2'`
* `READWRITE` When this is set to `true`, the WebDAV share can be written to (default: False). Example: `-e READWRITE=true`
* `BROWSABLE` When this is set to `true`, enable directory listings globally on the WebDAV share (default: False). Example: `-e BROWSABLE=true`

**IMPORTANT**: Should you use a persistent config volume, the WHITELIST and READWRITE variables will only have effect the first time. I.e., when you don't have a (custom) configuration yet.

## License

MIT / BSD

## Author Information

[Jeroen Geusebroek](http://jeroengeusebroek.nl/)

Dung Tri LE
