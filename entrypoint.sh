#!/bin/sh

set -e

addgroup -S -g $GID dkimpy-milter
adduser -S -u $UID -h /run/dkimpy-milter -D -H -s /sbin/nologin -G dkimpy-milter dkimpy-milter
mkdir /run/dkimpy-milter

#check if config read/write
if [ ! -w "/config/" ]
then
	echo "Unable to read or write config directory!"
	return 1
fi
if [ ! -w "/data/" ]
then
        echo "Unable to read or write data directory!"
        return 1
fi
if [ ! -w "/socket/" ]
then
        echo "Unable to read or write socket directory!"
        return 1
fi
/bin/chown -R dkimpy-milter:dkimpy-milter /config /socket /data /run/dkimpy-milter

exec /opt/venv/bin/dkimpy-milter /config/dkimpy-milter.conf -P /run/dkimpy-milter/dkimpy-milter.pid
